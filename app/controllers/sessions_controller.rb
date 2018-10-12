class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: %i[index create]

  def index
    @user = User.new
  end

  def create
    username = params.require(:user).permit(:username)
    @user = User.find_by_username(username)
    return redirect_to root_path, notice: "Username #{username} not found in the system" unless @user

    return redirect_to root_path, notice: 'Username/password combination incorrect' unless @user.authenticate(user_params('password'))

    session[:current_user] = @user.id
    redirect_to games_path, notice: 'Logged in successfully'
  end

  def destroy
    session[:current_user] = nil
    redirect_to root_path, notice: 'Logout Successful'
  end

  private

  def user_params(item)
    params.require(:user)[item]
  end
end
