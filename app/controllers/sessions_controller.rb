class SessionsController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @user = User.find_by_username user_params('username')
    return redirect_to root_path unless @user

    return redirect_to root_path unless @user.authenticate(user_params('password'))

    session[:current_user] = @user.id
    redirect_to games_path, notice: 'Logged in successfully'
  end

  private

  def user_params(item)
    params.require(:user)[item]
  end
end
