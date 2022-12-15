class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      log_in(user)
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user
    else
      flash[:error] = "Incorrect Credentials"
      redirect_to login_path
    end
  end

  def destroy
    session.destroy
    redirect_to root_path
  end

  private 

  def log_in(user)
    session[:user_id] = user.id
  end
end