class GamesController < ApplicationController
  def index
    render :index, locals: { games: Game.all }
  end

  def show; end

  def new
    @game = Game.new
  end

  def create
    game = Game.new game_params
    if game.save
      redirect_to games_path, notice: 'Successfully created game'
    else
      redirect_to games_path, notice: 'Game creation unsuccessful'
    end
  end

  private

  def initiate_go_fish
    go_fish = GoFish.new
    player = Player.new(User.find(session[:current_user]).name)
    go_fish.add_player(player) && go_fish
  end

  def game_params
    args = params.require(:game).permit(:name, :number_of_players).to_h
    args['data'] = initiate_go_fish.as_json
    args
  end
end
