class ApplicationController < ActionController::Base
  before_action :require_authentication, :clear_session_if_quit

  def require_authentication
    return if session[:current_user] && current_user

    redirect_to root_path, notice: 'Login to continue'
  end

  def clear_session_if_quit
    session[:selected] = {}
    session[:current_game] = nil
  end

  def current_user
    @current_user ||= User.find session[:current_user]
  end
end
