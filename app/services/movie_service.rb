require 'faraday'

class MovieService
  def self.movie_details(movie_id)
    response = MovieService.conn.get("movie/#{movie_id}?api_key=#{ENV["moviedb_api_key"]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.conn
    Faraday.new(url: "https://api.themoviedb.org/3/") do |faraday|
      faraday.adapter Faraday.default_adapter
    end
  end

  def self.movie_credits(movie_id)
    response = MovieService.conn.get("movie/#{movie_id}/credits?api_key=#{ENV["moviedb_api_key"]}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.movie_reviews(movie_id)
    response = MovieService.conn.get("movie/#{movie_id}/reviews?api_key=#{ENV["moviedb_api_key"]}")
    JSON.parse(response.body, symbolize_names: true)
  end
end