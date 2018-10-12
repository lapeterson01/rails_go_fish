class GamesController < ApplicationController
  def index
    render :index, locals: { games: Game.all }
  end

  def show; end

  def new; end
end
