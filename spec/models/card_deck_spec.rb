require 'rails_helper'

RSpec.describe CardDeck, type: :model do
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
end
