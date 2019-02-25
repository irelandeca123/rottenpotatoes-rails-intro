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
    #Added sorting list to store in a session 
    @sort = params[:sort]||session[:sort]
    #Sets all ratings (G, PG, PG-13 ..etc) equal to Movie.Ratings
    @all_ratings = Movie.ratings
    #Hashes ratings and orders ratings (Sorting)
    @ratings =  params[:ratings] || session[:ratings] || Hash[@all_ratings.map {|rating| [rating, rating]}]
    @movies = Movie.where(rating:@ratings.keys).order(@sort)
    #If statememnt in order to store each option (save) so if the user enters a certain rating it sorts it and saves it to session.
    if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
      session[:sort] = @sort
      session[:ratings] = @ratings
      flash.keep
      redirect_to movies_path(sort: session[:sort],ratings:session[:ratings])
    end
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
