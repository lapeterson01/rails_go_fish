class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by user_params
    @user.save
    session[:current_user] = @user.id
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
