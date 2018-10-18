class Player
  attr_reader :id, :name, :hand, :books

  def initialize(user, books = [])
    @id = user.id
    @name = user.name
    @hand = {}
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

  def add_book(rank)
    books << rank
  end

  def ==(other)
    id == other.id
  end

  def as_json
    {
      id: id,
      name: name,
      hand: hand.values.flat_map(&:as_json),
      books: books
    }
  end

  def self.from_json(data)
    player = new(User.find(data['id']), data['books'])
    data['hand'].each { |card| player.retrieve_card(PlayingCard.from_json(card)) }
    player
  end
end
