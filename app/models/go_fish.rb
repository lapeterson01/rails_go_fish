class GoFish
  include GoFishRoundHelper

  attr_reader :deck, :players, :turn

  DEAL_AMOUNT = 7

  def initialize(deck = CardDeck.new)
    @deck = deck
    @players = {}
  end

  def start
    deck.shuffle!
    DEAL_AMOUNT.times do
      players.each_value do |player|
        player.retrieve_card deck.deal
      end
    end
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
end
