class UsersController < ApplicationController
  skip_before_action :require_authentication, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    user = User.new user_params
    if user.save
      redirect_to root_path, notice: 'Signed up successfully'
    else
      redirect_to root_path, notice: 'Signup unsuccessful'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :password_confirmation)
  end
end
