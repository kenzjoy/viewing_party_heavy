require_relative '../facades/movie_facade'

class UsersController < ApplicationController
  def create
    return unless password_confirmation?

    if (new_user = User.new(user_params)).save
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
    if valid_login?(user = email_find(params[:email]))
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else
      flash[:error] = 'Incorrect Credentials. Please try again.'
      render :login_form
    end
  end

  private

  def user_params
    params[:user][:email].downcase!
    params.require(:user).permit(:name, :email, :password)
  end

  def password_confirmation?
    return true if params[:user][:password] == params[:user][:password_confirmation]

    redirect_to '/register'
    flash[:alert] = 'Error: Passwords must match'
    false
  end

  def email_find(email)
    User.find_by(email: email.downcase)
  end

  def valid_login?(user)
    return false unless params[:email].present? && params[:password].present?
    return false unless user
    return false unless user.authenticate(params[:password])

    true
  end

  def new_user_error(errors)
    redirect_to '/register'
    flash[:alert] = "Error: #{error_message(errors)}"
  end
end
