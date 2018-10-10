class Game < ApplicationRecord
  include GameRoundHelper

  attr_reader :deck, :players, :turn

  DEAL_AMOUNT = 7

  def initialize
    @deck = CardDeck.new
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
    # # TAKES CARD(S) FROM PLAYER AND GIVES IT TO TURN IF PLAYER HAS CARD(S)
    # if player.hand[rank]

    #   # creates round_result object
    #   round_result = { turn: round_helper.turn.name, rank_asked_for: rank, card_from: player.name, cards: [] }
    #   cards.each { |card| round_result[:cards].push(card) }

    # # TAKES CARD FROM DECK AND GIVES IT TO TURN
    # else

    #   # creates round_result object
    #   round_result = { turn: round_helper.turn.name, rank_asked_for: rank, card_from: 'pool', cards: [card] }
    # end

    # # NEED TO: add books to display

    # # ADDS BOOKS TO TURN IF TURN GOT ONE
    # round_helper.turn.hand.each_pair do |set, set_cards|

    #   # moves to next set if it has less than 4 cards
    #   next if set_cards.length < 4

    #   # adds 1 to turn books
    #   turn.books += 1

    #   # takes cards of book from turn
    #   turn.give_up_cards(set)
    # end

    # # assigns all player name strings to 'player_names'
    # player_names = players.keys

    # # CHANGES TO NEXT PLAYER IF TURN DID NOT GET CATCH
    # unless get_catch

    #   # goes to first player if last turn was last player
    #   round_helper.turn = if players.key(turn) == player_names.last
    #                         players[player_names[0]]

    #                       # other wise goes to next player
    #                       else
    #                         players[player_names[player_names.index(players.key(turn)) + 1]]
    #                       end
    # end

    # # RETURNS ROUND_RESULT HASH
    # round_result
  end

  def add_player(player)
    players[player.name] = player
    @turn = player if players.length == 1
  end
end
