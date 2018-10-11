class GoFish
  include GoFishRoundHelper

  attr_reader :deck, :players, :turn, :started, :round_result

  DEAL_AMOUNT = 7

  def initialize(deck = CardDeck.new, players = {}, turn = nil, round_result = nil)
    @deck = deck
    @players = players
    @turn = turn
    @round_result = round_result
    @started = false
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
    players[player.name] = player
    @turn = player if players.length == 1
  end

  def ==(other)
    deck == other.deck && players == other.players && turn == other.turn &&
      round_result == other.round_result
  end

  def as_json
    {
      deck: deck.as_json,
      players: players.values.map(&:as_json),
      turn: turn.name,
      round_result: round_result
    }
  end

  def self.from_json(data)
    players = data['players'].map { |player| [player['name'], Player.from_json(player)] }.to_h
    new(CardDeck.from_json(data['deck']), players, players[data['turn']], data['round_result'])
  end
end
