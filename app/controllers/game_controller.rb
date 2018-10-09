class GameController < ApplicationController
  def home
    @user = User.new
  end

  def lobby;  end
end
