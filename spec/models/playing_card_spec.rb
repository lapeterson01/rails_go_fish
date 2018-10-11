require 'rails_helper'

RSpec.describe PlayingCard, type: :model do
  let(:card1) { PlayingCard.new('A', 'Spades') }

  describe '#initialize' do
    it 'creates a standard playing card with rank and suit' do
      expect(card1.rank).to eq 'A'
      expect(card1.suit).to eq 'Spades'
    end
  end

  describe 'equality' do
    it 'allows two instances of PlayingCard to be equal if rank and suit are equal' do
      card2 = PlayingCard.new('A', 'Spades')
      expect(card1).to eq card2
      card3 = PlayingCard.new('Q', 'Hearts')
      expect(card1).to_not eq card3
    end
  end

  describe 'json methods' do
    it 'allows playingcard data to be converted to json object' do
      expect(card1.as_json).to eq(rank: card1.rank, suit: card1.suit)
    end

    it 'allows playingcard json object to be converted to class instance' do
      expect(PlayingCard.from_json(card1.as_json.stringify_keys)).to eq card1
    end
  end
end
