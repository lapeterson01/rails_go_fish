module GameRoundHelper
  attr_reader :player, :rank

  def set_player_and_rank(player, rank)
    @player = player
    @rank = rank
  end

  def player_has_card
    player.give_up_cards(rank).each { |card| turn.retrieve_card(card) }
    @get_catch = true
  end

  def go_fish
    turn.retrieve_card(deck.deal)
    @get_catch = false
  end
end
