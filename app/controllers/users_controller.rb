require_relative '../facades/movie_facade'

class UsersController < ApplicationController
  def new
  end

  def create
    fix_raw_params
    new_user = User.new(user_params)
    return password_error(new_user.errors) unless password_match?

    if new_user.save
      flash[:success] = "Welcome, #{new_user.email}!"
      redirect_to "/users/#{new_user.id}"
    else
      new_user_error(new_user.errors)
    end
  end

  def show
    @user_parties = @user.user_parties
    @parties_info = @user.movie_cards_info
  end

  def login_user
    fix_raw_params
    user = User.find_by(email: params[:email])
    if valid_login_params? && user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = 'Incorrect Credentials. Please try again.'
      render :login_form
    end
  end

  private

  def password_match?
    params[:user][:password] == params[:user][:password_confirmation]
  end

  def fix_raw_params
    params[:user][:email] = params[:user][:email].downcase if params[:user]
    params[:email] = params[:email].downcase unless params[:user]
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def valid_login_params?
    params[:email].present? && params[:password].present?
  end

  def password_error(errors)
    redirect_to '/register'
    flash[:alert] = "Error: Passwords must match #{", #{error_message(errors)}" if errors}"
  end
  
  def new_user_error(errors)
    redirect_to '/register'
    flash[:alert] = "Error: #{error_message(errors)}"
  end
end