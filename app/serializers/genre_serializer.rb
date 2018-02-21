class GenreSerializer < ActiveModel::Serializer
  attributes :id, :name, :db_id
  link(:self) { genre_url(object) }

  # def genres
end