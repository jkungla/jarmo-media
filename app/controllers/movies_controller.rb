class MoviesController < ApplicationController

  def index
    movies = Movie.all
    render json: movies
  end

  def show
    movies = Movie.find(params[:id])
    render json: movies
  end
end