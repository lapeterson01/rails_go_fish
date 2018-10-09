require_relative 'playing_card'

class CardDeck
  attr_reader :cards

  RANKS = %w[A K Q J 10 9 8 7 6 5 4 3 2].freeze
  SUITS = %w[Spades Clubs Diamonds Hearts].freeze

  def initialize(cards = create_deck)
    @cards = cards
  end

  def shuffle!
    cards.shuffle!
  end

  def deal
    cards.shift
  end

  def out_of_cards?
    cards.empty?
  end

  def ==(other)
    equal = true
    other.cards.each do |card2|
      equal = false if cards[other.cards.index(card2)] != card2
    end
    equal
  end

  private

  def create_deck
    RANKS.map { |rank| SUITS.map { |suit| PlayingCard.new(rank, suit) } }.flatten
  end
end
