class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :year
      t.string :quality
      t.text :overview
      t.string :lang
      t.string :url
      t.string :poster
      t.decimal :db_popularity
      t.decimal :db_vote_average
      t.integer :db_vote_count
      t.integer :db_id
      t.timestamps
    end
    add_index :movies, :url, unique: true

    create_table :genres do |t|
      t.string :name
      t.integer :db_id
      t.timestamps
    end

    create_table :movie_genres do |t|
      t.belongs_to :movie, index: true
      t.belongs_to :genre, index: true
      t.timestamps
    end
  end
end
