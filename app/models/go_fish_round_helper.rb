module GoFishRoundHelper
  attr_reader :player, :rank, :get_catch, :round_result

  def set_player_and_rank(player, rank)
    @player = player
    @rank = rank
    @round_result = { turn: turn, card_from: player, rank_asked_for: rank }
  end

  def player_has_card
    round_result[:cards] = player.give_up_cards(rank).each { |card| turn.retrieve_card(card) }
    @get_catch = true
  end

  def go_fish
    turn.retrieve_card(round_result[:cards] = deck.deal)
    @get_catch = false
  end

  def calculate_books
    turn.hand.each_pair do |set, set_cards|
      next if set_cards.length < 4

      turn.books += 1
      round_result[:books] = 1
      turn.give_up_cards(set)
    end
  end

  def next_turn
    @turn = if turn == players.values.last
              players.values.first
            else
              players.values[players.values.index(turn) + 1]
            end
  end
end
