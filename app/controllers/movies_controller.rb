class MoviesController < ApplicationController

  def index
    if params[:genre] and params[:genre] != "0"
      movies = Movie.joins(:genres).where('genres.id = ?', params[:genre])
    else
      movies = Movie.all
    end

    render json: movies
  end

  def show
    movie = Movie.find(params[:id])
    render json: movie
  end
end