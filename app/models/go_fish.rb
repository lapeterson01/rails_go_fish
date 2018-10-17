class GoFish
  include GoFishRoundHelper

  attr_reader :deck, :players, :turn, :started, :round_result

  DEAL_AMOUNT = 7

  def initialize(deck = deck_env, players = {}, turn = nil, round_result = nil, started = false)
    @deck = deck
    @players = players
    @turn = turn
    @round_result = round_result
    @started = started
  end

  def start
    deck.shuffle!
    DEAL_AMOUNT.times do
      players.each_value do |player|
        player.retrieve_card deck.deal
      end
    end
    @started = true
  end

  def play_round(player, rank)
    set_player_and_rank(player, rank)
    player.hand[rank] ? player_has_card : go_fish
    calculate_books
    next_turn unless get_catch
  end

  def winner
    return unless players.values.any?(&:out_of_cards?) || deck.out_of_cards?

    winners = players.values.map { |player| [player, player.books] }.to_h
    winners.select { |_player, books| books == winners.values.max }.keys
  end

  def add_player(player)
    players[player.id] = player
    @turn = player.id if players.length == 1
  end

  def ==(other)
    deck == other.deck && players == other.players && turn == other.turn &&
      round_result == other.round_result
  end

  def other_players(player)
    players.reject { |_key, value| value == player }
  end

  # rubocop:disable Metrics/MethodLength
  def as_json
    round_result[:cards] = round_result[:cards].map(&:as_json) if round_result
    {
      deck: deck.as_json,
      players: players.values.map(&:as_json),
      turn: turn,
      round_result: round_result,
      started: started
    }
  end
  # rubocop:enable Metrics/MethodLength

  def self.from_json(data)
    if data['round_result']
      data['round_result']['cards'] = data['round_result']['cards'].map do |card|
        PlayingCard.from_json(card)
      end
    end
    players = data['players'].map { |player| [player['id'], Player.from_json(player)] }.to_h
    new(deck_env_json(data['deck']), players, data['turn'], data['round_result'], data['started'])
  end

  def self.deck_env_json(data)
    Rails.env.test? ? TestDeck.from_json(data) : CardDeck.from_json(data)
  end

  private_class_method :deck_env_json

  private

  def deck_env
    Rails.env.test? ? TestDeck.new : CardDeck.new
  end
end
