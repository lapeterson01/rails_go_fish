class GamesController < ApplicationController
  skip_before_action :clear_session_if_quit,
                     only: %i[show play_view update select_card select_player play_round]

  def index
    render :index, locals: { games: Game.all }
  end

  def show
    session[:current_game] = params['id']
    game = Game.find(params['id'])
    return play_view(game) if game.data['started']

    render :show, locals: show_locals(game)
  end

  def play_view(game)
    render :play, locals: {
      go_fish: game.go_fish,
      current_player: game.current_player(session[:current_user]),
      selected: session[:selected],
      result: game.format_round_result(session[:current_user]),
      book_result: game.format_book_result(session[:current_user])
    }
  end

  def new
    @game = Game.new
  end

  def create
    game = Game.find_or_initialize_by game_params
    game.add_player_to_game(current_user)
    message = game.id ? 'Successfully created game' : 'Game creation unsuccessful'
    return redirect_to games_path, notice: message if game.host == current_user.id

    redirect_to game_path(game.id), notice: 'Successfully joined'
  end

  def update
    game = Game.find(session[:current_game])
    game.start_game
    redirect_to game_path(game.id), notice: 'Game Started'
  end

  def select_player
    session[:selected]['player'] = params['player_id'].to_i
    redirect_to game_path(session[:current_game])
  end

  def select_card
    session[:selected]['card'] = params['card']
    redirect_to game_path(session[:current_game])
  end

  def play_round
    game = Game.find(session[:current_game])
    game.play_round(session[:selected])
    session[:selected] = {}
    redirect_to game_path(session[:current_game])
  end

  private

  def game_params
    return { 'id' => params['id'] } if params['id']

    args = params.require(:game).permit(:name, :number_of_players).to_h
    args['host'] = current_user.id
    args
  end

  def show_locals(game)
    {
      players: game.players,
      current_player: User.find(session[:current_user]),
      id: game.id,
      host: game.host,
      started: game.data['started']
    }
  end
end
