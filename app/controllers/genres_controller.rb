class GenresController < ApplicationController

  def index
    genres = Genre.all
    render json: genres
  end

  def show
    genres = Genre.find(params[:id])
    render json: genres
  end
end