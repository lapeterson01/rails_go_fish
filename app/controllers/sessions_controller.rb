class SessionsController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @user = User.find_by_username user_params('username')
    if @user
      if @user.authenticate(user_params('password'))
        session[:current_user] = @user.id
        redirect_to users_path, notice: 'Logged in successfully'
      else
        redirect_to root_path
      end
    end
  end

  private

  def user_params(item)
    params.require(:user)[item]
  end
end
