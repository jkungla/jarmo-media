class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :year, :quality, :overview, :lang, :url, :poster, :db_popularity, :db_vote_average, :db_id
  attribute :genres
  link(:self) { movie_url(object) }

  def genres
    object.genres.map do |ii|
      GenreSerializer.new(ii)
    end
  end
end