class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: %i[index create]

  def index
    @user = User.new
  end

  def create
    user = User.find_by_username(user_params['username'])
    return redirect_to root_path, notice: signin_notice('no user') unless user

    unless user.authenticate(user_params['password'])
      return redirect_to root_path, notice: signin_notice('wrong password')
    end

    session[:current_user], session[:host] = user.id, []
    redirect_to games_path, notice: 'Logged in successfully'
  end

  def destroy
    session[:current_user] = nil
    redirect_to root_path, notice: 'Logout Successful'
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def signin_notice(context)
    return "Username #{user_params['username']} not found in the system" if context == 'no user'

    return 'Username/password combination incorrect' if context == 'wrong password'
  end
end
