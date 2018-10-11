class Player
  attr_reader :name, :hand
  attr_accessor :books

  def initialize(name, hand = {}, books = 0)
    @name = name
    @hand = hand
    @books = books
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

  def out_of_cards?
    hand.empty?
  end

  def ==(other)
    name == other.name
  end

  def as_json
    {
      name: name,
      hand: hand,
      books: books
    }
  end

  def self.from_json(data)
    new(data['name'], data['hand'], data['books'])
  end
end
