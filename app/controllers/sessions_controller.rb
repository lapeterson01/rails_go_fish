class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_or_initialize_by user_params
    if @user.save
      session[:current_user] = @user.id
      redirect_to users_path, notice: 'Logged in successfully'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
