class Player
  attr_reader :name, :hand
  attr_accessor :books

  def initialize(name)
    @name = name
    @hand = {}
    @books = 0
  end

  def retrieve_card(card)
    hand[card.rank] = [] unless hand[card.rank]
    hand[card.rank].push(card)
  end

  def give_up_cards(rank)
    hand.delete(rank)
  end

  def count_hand
    count = 0
    hand.each_value { |set| count += set.length }
    count
  end
end
