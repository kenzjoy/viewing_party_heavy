require_relative '../facades/movie_facade'

class UsersController < ApplicationController
  before_action :validate_user, only: :show

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user.id)
      flash[:success] = "Welcome, #{user.name}!"
    else
      redirect_to new_user_path
      flash[:alert] = "Error: #{error_message(user.errors)}"
    end
  end

  def show
    @user = User.find(params[:id])
    session[:user_id] = @user.id
    @user_parties = @user.user_parties
    @parties_info = @user.movie_cards_info
  end

  def discover
  end
  
  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def validate_user
    if session[:user_id].nil?
       redirect_to root_path
       flash[:alert] = 'You must log in to view your dashboard'
    end
  end
end