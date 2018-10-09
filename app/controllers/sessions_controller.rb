class SessionsController < ApplicationController
  def signin
    @user = User.find_or_initialize_by user_params
    @user.save
    session[:current_user] = @user.id
    redirect_to lobby_path
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
