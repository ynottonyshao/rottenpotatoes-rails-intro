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

    if params[:ratings].nil?
      @selected_ratings = @all_ratings
    else
      @selected_ratings = params[:ratings].keys
    end

    if params[:sort] == 'title'
      # sort movies by title
      sorted_by = {:title => :asc}
      @title_header = 'hilite'
    elsif params[:sort] == 'release_date'
      # sort movies by release date
      sorted_by = {:release_date => :asc}
      @release_date_header = 'hilite'
    end

    @movies = Movie.order(sorted_by).where(rating: @selected_ratings)
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
