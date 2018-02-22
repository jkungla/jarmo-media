class Settings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name
      t.string :value
      t.timestamps
    end

    Setting.create!(:name => "movie_api_key", :value => "3ecc82f64cc674208e8f2b1b5ea9a400")
    Setting.create!(:name => "movie_dir_mp4", :value => "/var/www/html/videos/*.mp4")
  end
end
