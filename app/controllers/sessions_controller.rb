class SessionsController < ApplicationController
  def signin
    @user = User.find_or_initialize_by user_params
    @user.save
    signed_in_user = User.find_by_name(@user.name)
    session[:current_user] = signed_in_user.id
    redirect_to lobby_path
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
