module GoFishRoundHelper
  attr_reader :get_catch, :selected_player, :selected_rank

  VALUES = { 'A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11 }.freeze

  # def select_rank(rank)
  #   @selected_rank = rank
  #   @round_result = { turn: turn, rank_asked_for: rank }
  # end

  # def select_player(player_id)
  #   @selected_player = players[player_id]
  #   @round_result[:card_from] = player_id
  # end

  def set_player_and_rank(player_id, rank)
    @selected_player = players[player_id.to_i]
    @selected_rank = rank
    @round_result = { turn: turn, card_from: player_id, rank_asked_for: rank }
  end

  def player_has_card
    round_result[:cards] = selected_player.give_up_cards(selected_rank).each do |card|
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

      players[turn].add_book(set)
      round_result[:books] = turn
      players[turn].give_up_cards(set)
    end
    @selected_rank, @selected_player = nil, nil
  end

  def next_turn
    @turn = if turn == players.keys.last
              players.keys.first
            else
              players.keys[players.keys.index(turn) + 1]
            end
  end

  def tie_breaker(winners)
    winners.max_by do |player|
      score = 0
      player.books.each do |rank|
        score += VALUES[rank] || rank.to_i
      end
      score
    end
  end
end
