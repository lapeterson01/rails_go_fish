class GamesController < ApplicationController
  skip_before_action :clear_session_if_quit, only: %i[show select_card select_player play_round]

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
    go_fish = GoFish.from_json(game.data)
    render :play, locals: {
      go_fish: go_fish,
      current_player: go_fish.players[session[:current_user]],
      selected: session[:selected],
      result: format_round_result(go_fish)
    }
  end

  def new
    @game = Game.new
  end

  def create
    binding.pry
    game = Game.find_or_initialize_by game_params
    game.add_player_to_game(current_user)
    message = game.id ? 'Successfully created game' : 'Game creation unsuccessful'
    return redirect_to games_path, notice: message if game.host == current_user.id

    redirect_to game_path(game.id), notice: 'Successfully joined'
  end

  def update
    game = Game.find(session[:current_game])
    if params['_method'] == 'put'
      game.add_player_to_game(current_user)
      redirect_to game_path(params['id']), notice: 'Successfully joined'
    elsif params['_method'] == 'patch'
      start_game
      redirect_to game_path(params['id']), notice: 'Game Started'
    end
  end

  def select_player
    game = Game.find(session[:current_game])
    go_fish = GoFish.from_json(game.data)
    player = go_fish.players[params['player_id'].to_i]
    session[:selected]['player'] = player.id
    redirect_to game_path(session[:current_game])
  end

  def select_card
    session[:selected]['card'] = params['card']
    redirect_to game_path(session[:current_game])
  end

  def play_round
    game = Game.find(session[:current_game])
    go_fish = GoFish.from_json(game.data)
    player = go_fish.players[session[:selected]['player'].to_i]
    go_fish.play_round(player, session[:selected]['card'])
    game.data = go_fish.as_json
    game.save
    session[:selected] = {}
    redirect_to game_path(session[:current_game])
  end

  private

  # def initiate_go_fish
  #   go_fish = GoFish.new
  #   user = User.find(session[:current_user])
  #   player = Player.new(user.id, user.name)
  #   go_fish.add_player(player) && go_fish
  # end

  def game_params
    return args = { 'id' => params['id'] } if params['id']
    
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

  def format_round_result(go_fish)
    return unless go_fish.round_result

    cards = go_fish.round_result['cards'].map(&:to_s)
    if go_fish.round_result['turn'] == session[:current_user]
      if go_fish.round_result['card_from'] == 'pool'
        "You drew #{cards.join(', ')} from the pool"
      else
        "You took #{cards.join(', ')} from #{go_fish.players[go_fish.round_result['card_from']].name}"
      end
    else
      if go_fish.round_result['card_from'] == 'pool'
        "#{go_fish.players[go_fish.round_result['turn']].name} drew #{cards.join(', ')} from the pool"
      elsif go_fish.round_result['card_from'] == session[:current_user]
        "#{go_fish.players[go_fish.round_result['turn']].name} took #{cards.join(', ')} from you"
      else
        "#{go_fish.players[go_fish.round_result['turn']].name} took #{cards.join(', ')} from #{go_fish.players[go_fish.round_result['card_from']].name}"
      end
    end
  end

  # def add_player_to_game
  #   game = Game.find(params['id'])
  #   user = User.find(session[:current_user])
  #   game.users << user unless game.users.any? { |game_user| game_user == user }
  #   user.games << game unless user.games.any? { |user_game| user_game == game }
  #   go_fish = GoFish.from_json(game.data)
  #   go_fish.add_player(Player.new(user.id, user.name))
  #   game.data = go_fish.as_json
  #   game.save
  # end

  def start_game
    game = Game.find(params['id'])
    go_fish = GoFish.from_json(game.data)
    go_fish.start
    game.data = go_fish.as_json
    game.save
  end
end
