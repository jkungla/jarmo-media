require 'open-uri'
class VideosController < ActionController::API
  HOST = "https://api.themoviedb.org/3/search/movie?"

  def index
    genres = JSON.load(open("https://api.themoviedb.org/3/genre/movie/list?api_key=3ecc82f64cc674208e8f2b1b5ea9a400&language=en-US"))
    p genres
    Genre.delete_all
    genres['genres'].each do |genre|
      Genre.create(name: genre['name'], db_id: genre['id'])
    end

    files = Dir.glob('/var/www/html/videos/*.mp4').select{ |e| File.file? e }
    files.each do |file|
      nimi, year, qualy = parse_filename(File.basename(file, '.mp4'))
      url = HOST + "api_key=3ecc82f64cc674208e8f2b1b5ea9a400" + "&include_adult=true&query=" + URI.encode(nimi)
      url = url + "&year=" + year if year != ''
      data = JSON.load(open(url))
      p data
      if data['total_results'] == 1
        movie = data['results'][0]
        new = Movie.create(title: movie['title'], year: year, quality: qualy, overview: movie['overview'], lang: movie['original_language'],
                      url: URI.encode(File.basename(file)), poster: movie['poster_path'], db_popularity: movie['popularity'], db_vote_average: movie['vote_average'], db_id: movie['id'])
        movie['genre_ids'].each do |genre_id|
          genre = Genre.where(db_id: genre_id).first
          if genre
            MovieGenre.create(movie_id: new.id, genre_id: genre.id)
          end
        end
      end
    end
    render json: {}
  end

  def show
    filename = Rails.root.join('videos', params[:id] + '.mp4')
    send_file filename, type: "video/mp4", disposition: "inline", range: true
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