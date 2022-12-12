require 'rails_helper'

RSpec.describe Movie, :vcr do
  before(:each) do
    @movie_details = MovieService.movie_details(550)
    @movie_reviews = MovieService.movie_reviews(550)
    @movie_credits = MovieService.movie_credits(550)
    @movie = Movie.new(@movie_details, @movie_reviews, @movie_credits)
  end

  describe '#initialize' do
    it '- exists' do 
      expect(@movie).to be_a(Movie)
      expect(@movie.id).to eq(550)
      expect(@movie.movie_title).to eq("Fight Club")
      expect(@movie.movie_image).to eq("/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg")
      expect(@movie.vote_average).to be_a(Float)
      expect(@movie.runtime).to be_an(Integer)
      expect(@movie.genres).to eq(["Drama", "Thriller", "Comedy"])
      expect(@movie.summary_description).to eq("A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
      expect(@movie.cast.first).to eq(["Edward Norton", "The Narrator"])
      expect(@movie.reviews).to be_a(Hash)
      expect(@movie.total_reviews).to be_an(Integer)
    end
  end

  describe '#get_genres(movie_details)' do 
    it '- formats the movies genres into an array of strings' do
      expect(@movie.get_genres(@movie_details)).to eq(["Drama", "Thriller", "Comedy"])
    end
  end

  describe '#get_reviews(movie_reviews)' do
    it '- formats the reviews into a hash of the authors name and their review' do
      expect(@movie.get_reviews(@movie_reviews).keys[0]).to be_a(String)
      expect(@movie.get_reviews(@movie_reviews).values[0]).to be_a(String)
    end
  end

  describe '#get_cast(movie_credits)' do
    it '- formats the cast into a nested arrary with the actor name & character name in each sub array' do
      expect(@movie.get_cast(@movie_credits)).to eq([
                    ["Edward Norton", "The Narrator"],
                    ["Brad Pitt", "Tyler Durden"],
                    ["Helena Bonham Carter", "Marla Singer"],
                    ["Meat Loaf", "Robert \"Bob\" Paulson"],
                    ["Jared Leto", "Angel Face"],
                    ["Zach Grenier", "Richard Chesler"],
                    ["Holt McCallany", "The Mechanic"],
                    ["Eion Bailey", "Ricky"],
                    ["Richmond Arquette", "Intern"],
                    ["David Andrews", "Thomas"]
      ])
    end
  end
end




# describe '#vote_average(movie_id)' do
    #   it '- returns the vote average of a given movie id' do
    #     expect(MovieFacade.vote_average(550)).to eq(8.428)
    #   end
    # end

    # describe '#runtime(movie_id)' do
    #   it '- returns the runtime in hours & minutes of a given movie id' do
    #     expect(MovieFacade.runtime(550)).to eq(139)
    #   end
    # end

    # describe '#genres(movie_id)' do
    #   it '- returns the genres associated to a given movie id' do
    #     expect(MovieFacade.genres(550)).to eq(["Drama", "Thriller", "Comedy"])
    #   end
    # end

    # describe '#summary_description(movie_id)' do
    #   it '- returns the summary description of a given movie id' do
    #     expect(MovieFacade.summary_description(550)).to eq("A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
    #   end
    # end