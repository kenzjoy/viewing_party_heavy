class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :set_user, except: [:landing]

  private
  def error_message(errors)
    errors.full_messages.join(', ')
  end

  def set_user
    if params[:user_id].present?
      @user = User.find(params[:user_id])
    elsif params[:id].present?
      @user = User.find(params[:id])
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
