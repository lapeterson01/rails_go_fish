class ApplicationController < ActionController::Base
  before_action :require_authentication

  def require_authentication
    return if session[:current_user] && current_user

    redirect_to new_user_path, notice: 'Login to continue'
  end

  def current_user
    @current_user ||= User.find session[:current_user]
  end
end
