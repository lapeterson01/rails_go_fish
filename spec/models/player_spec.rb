require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { Player.new('Player') }
  let(:card1) { PlayingCard.new('A', 'Spades') }

  describe '#initialize' do
    it 'begins with given name and an empty hand and books count set to 0' do
      expect(player.name).to eq 'Player'
      expect(player.count_hand && player.books).to eq 0
    end
  end

  describe '#retrieve_card' do
    it 'takes in a card and adds it to player hand' do
      player.retrieve_card(card1)
      expect(player.count_hand).to eq 1
      expect(player.hand['A']).to eq [card1]
    end
  end

  describe '#give_up_cards' do
    it 'removes all cards of specified rank from player hand and returns it' do
      cards = [card2 = PlayingCard.new('A', 'Clubs'), PlayingCard.new('Q', 'Hearts')]
      cards.push(card1)
      cards.each { |card| player.retrieve_card(card) }
      expect(player.give_up_cards(card1.rank)).to eq [card2, card1]
      expect(player.count_hand).to eq 1
    end
  end
end
