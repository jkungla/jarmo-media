require 'open-uri'
class VideosController < ActionController::API
  SEARCH_MOVIE_HOST = 'https://api.themoviedb.org/3/search/movie?'
  SEARCH_GENRES_HOST = 'https://api.themoviedb.org/3/genre/movie/list?'

  def index
    genres = JSON.load(open(SEARCH_GENRES_HOST + 'api_key=' + Setting['movie_api_key'] + '&language=en-US'))
    Genre.delete_all
    genres['genres'].each do |genre|
      Genre.create(name: genre['name'], db_id: genre['id'])
    end

    files = Dir.glob(Setting['movie_dir_mp4']).select{ |e| File.file? e }
    movie_ids = []
    files.each do |file|
      old = Movie.where(url: URI.encode(File.basename(file))).first
      if old
        movie_ids.push(old.id)
      else
        nimi, year, qualy = parse_filename(File.basename(file, '.mp4'))
        url = SEARCH_MOVIE_HOST + 'api_key=' + Setting['movie_api_key'] + '&include_adult=true&query=' + URI.encode(nimi)
        url = url + '&year=' + year if year != ''
        data = JSON.load(open(url))
        if data['total_results'] > 1
          movie = data['results'][0]
          new = Movie.create(title: movie['title'], year: year, quality: qualy, overview: movie['overview'], lang: movie['original_language'],
                             url: URI.encode(File.basename(file)), poster: movie['poster_path'], db_popularity: movie['popularity'], db_vote_average: movie['vote_average'], db_id: movie['id'])
          movie['genre_ids'].each do |genre_id|
            genre = Genre.where(db_id: genre_id).first
            if genre
              MovieGenre.create(movie_id: new.id, genre_id: genre.id)
            end
          end
          movie_ids.push(old.id)
        end
      end
    end
    Movie.where.not(id: movie_ids).delete_all
    render json: {}
  end

  def show
    filename = Rails.root.join('videos', params[:id] + '.mp4')
    send_file filename, type: 'video/mp4', disposition: 'inline', range: true
  end

  private

  def parse_filename(filename)
    nimi = ''
    qualy = ''
    year = ''

    arr = filename.gsub('.', ' ').split(' ')
    arr.each do |str|
      if str.match(/^[0-9]+/)
        if str.match(/^\d{4}$/)
          year = str
        elsif str.match(/^[0-9]+p/)
          qualy = str
        elsif year == ''
          if nimi == ''
            nimi = str
          else
            nimi = nimi + ' ' + str
          end
        end
      elsif year == ''
        if nimi == ''
          nimi = str
        else
          nimi = nimi + ' ' + str
        end
      end
    end
    [nimi, year, qualy]
  end
end