class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.distinct.pluck(:rating)

    # puts("PARAMS SORT: ", params[:sort])
    # puts("SESSION SORT: ", session[:sort])
    # puts("-----------------------------")
    
    if params[:sort] == 'title'
      # sort movies by title
      @sort_by = {:title => :asc}
      @title_header = 'hilite'
    elsif params[:sort] == 'release_date'
      # sort movies by release date
      @sort_by = {:release_date => :asc}
      @release_date_header = 'hilite'
    else
      @sort_by = session[:sort]
    end

    # puts("SORT BY: ", @sort_by)

    @selected_ratings = {}
    if params[:ratings].nil?
      @selected_ratings = session[:ratings] || @all_ratings
    else
      @selected_ratings = params[:ratings].keys
    end
    
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      session[:ratings] = @selected_ratings
      session[:sort] = @sort_by
    end

    @movies = Movie.order(@sort_by).where(rating: @selected_ratings)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
