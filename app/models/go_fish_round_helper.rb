module GoFishRoundHelper
  attr_reader :player, :rank, :get_catch

  def set_player_and_rank(player, rank)
    @player = player
    @rank = rank
    @round_result = { turn: turn, card_from: player.id, rank_asked_for: rank }
  end

  def player_has_card
    round_result[:cards] = player.give_up_cards(rank).each do |card|
      players[turn].retrieve_card(card)
    end
    @get_catch = true
  end

  def go_fish
    round_result[:cards] = [deck.deal].each { |card| players[turn].retrieve_card(card) }
    round_result[:card_from] = 'pool'
    @get_catch = false
  end

  def calculate_books
    players[turn].hand.each_pair do |set, set_cards|
      next if set_cards.length < 4

      players[turn].books += 1
      round_result[:books] = 1
      players[turn].give_up_cards(set)
    end
  end

  def next_turn
    @turn = if turn == players.keys.last
              players.keys.first
            else
              players.keys[players.keys.index(turn) + 1]
            end
  end
end
