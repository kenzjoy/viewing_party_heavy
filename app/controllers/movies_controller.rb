class MoviesController < ApplicationController
  before_action :validate_user, only: :show

  def index
    if (params[:q] == 'top rated' && !params[:commit].present?) || params[:q] == ''
      @movies = MovieFacade.top_rated
      @subtitle = 'Top Rated Movies'
    elsif params[:q].present?
      @movies = MovieFacade.search(params[:q])
      @subtitle = "Movie results for: '#{params[:q]}'"
    # else
    #   redirect_to discover_path(@user)
    #   flash[:alert] = 'Something went wrong, please try again'
    end
  end

  def show
    @user = User.find(params[:user_id])
    session[:user_id] = @user.id
    @movie = MovieFacade.new_movie_details(params[:id])
  end

  private

  def validate_user
    @user = User.find(params[:user_id])
    @movie = MovieFacade.new_movie_details(params[:id])
    if session[:user_id].nil?
      render
      flash[:alert] = 'You must log in to create a viewing party'
    end
  end

end