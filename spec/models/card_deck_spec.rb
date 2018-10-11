require 'rails_helper'

RSpec.describe CardDeck, type: :model do
  def test_from_json(card)
    {
      'rank' => card.rank,
      'suit' => card.suit
    }
  end

  let(:deck1) { CardDeck.new }
  let(:deck2) { CardDeck.new }

  describe '#initialize' do
    it 'creates a deck of 52 standard playing cards' do
      expect(deck1.cards.length).to eq 52
    end
  end

  describe '#shuffle!' do
    it 'shuffles the deck of cards' do
      expect(deck1).to eq deck2
      deck1.shuffle!
      expect(deck1).to_not eq deck2
    end
  end

  describe 'equality' do
    it 'allows two instances of CardDeck to be equal if the cards are equal' do
      expect(deck1).to eq deck2
    end
  end

  describe '#deal' do
    it 'returns the top card from the deck' do
      card = deck1.deal
      expect(card).to eq PlayingCard.new('A', 'Spades')
      expect(deck1.cards.length).to eq 51
    end
  end

  describe '#out_of_cards?' do
    let(:deck2) { CardDeck.new([]) }

    it 'returns true if the deck is out of cards and false if it is not' do
      expect(deck1.out_of_cards?).to eq false
      expect(deck2.out_of_cards?).to eq true
    end
  end

  describe 'json methods' do
    it 'allows carddeck data to be converted to json object' do
      expect(deck1.as_json).to eq(cards: deck1.cards.map(&:as_json))
    end

    it 'allows carddeck json object to be converted to class instance' do
      expect(CardDeck.from_json('cards' => deck1.as_json[:cards].map(&:stringify_keys))).to eq deck1
    end
  end
end
