require 'rails_helper'

RSpec.describe Game, type: :model do
  def round_result_expectations(cards, round_result = game.round_result, player = game.player, rank = game.rank, turn = game.turn)
    expect(round_result[:card_from]).to eq player
    expect(round_result[:cards]).to eq cards
    expect(round_result[:rank_asked_for]).to eq rank
    expect(round_result[:turn]).to eq turn
  end

  let(:game) { Game.new }
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:players) { [player1, player2] }

  describe '#initialize' do
    it 'begins with deck of 52 standard playing cards' do
      expect(game.deck).to eq CardDeck.new
    end

    it 'begins with empty players hash' do
      expect(game.players).to eq({})
    end
  end

  describe 'gameplay' do
    before do
      players.each { |player| game.add_player(player) }
    end

    describe '#start' do
      it 'shuffles the deck' do
        deck = CardDeck.new
        expect(game.deck).to eq deck
        game.start
        14.times { deck.deal }
        expect(game.deck).to_not eq deck
      end

      it 'deals deck to players' do
        game.start
        expect(game.deck.cards.length).to eq 38
        expect(player1.count_hand && player2.count_hand).to eq 7
      end
    end

    describe '#play_round' do
      let(:card1) { PlayingCard.new('A', 'Spades') }
      let(:card2) { PlayingCard.new('A', 'Clubs') }

      before do
        player1.retrieve_card(card1)
        player2.retrieve_card(card2)
      end

      describe '#set_player_and_rank' do
        it 'sets player and rank' do
          game.set_player_and_rank(player2, card2.rank)
          expect(game.player).to eq player2
          expect(game.rank).to eq card2.rank
        end
      end

      describe '#player_has_card' do
        it 'takes card from player if player has card and returns true (turn got catch)' do
          game.set_player_and_rank(player2, card2.rank)
          game.player_has_card
          expect(game.get_catch).to eq true
          expect(player1.count_hand).to eq 2
          expect(player2.count_hand).to eq 0
        end
      end

      describe '#go_fish' do
        it 'takes card from deck and gives it to turn and returns false (turn did not get catch)' do
          game.set_player_and_rank(player2, 'Q')
          game.go_fish
          expect(game.get_catch).to eq false
          expect(player1.count_hand).to eq 2
          expect(player2.count_hand).to eq 1
        end
      end

      describe '#calculate_books' do
        before do
          [PlayingCard.new('A', 'Diamonds'), PlayingCard.new('A', 'Hearts')].each do |card|
            player2.retrieve_card(card)
          end
        end

        it 'determines if turn got any books during turn' do
          game.set_player_and_rank(player2, 'A')
          game.player_has_card
          game.calculate_books
          expect(player1.count_hand).to eq 0
          expect(player1.books).to eq 1
        end
      end

      describe '#next_turn' do
        it 'goes to the next turn' do
          game.next_turn
          expect(game.turn).to eq player2
          game.next_turn
          expect(game.turn).to eq player1
        end
      end

      describe '#round_result' do
        let(:card3) { PlayingCard.new('A', 'Diamonds') }
        let(:card4) { PlayingCard.new('A', 'Hearts') }
        let(:card5) { PlayingCard.new('Q', 'Hearts') }

        it 'creates a hash to return with the results of the round' do
          [card3, card4].each { |card| player2.retrieve_card(card) }
          game.set_player_and_rank(player2, 'A')
          game.player_has_card
          game.calculate_books
          round_result_expectations([card2, card3, card4])
          expect(game.round_result[:books]).to eq 1
        end

        it 'resets on next player turn' do
          player2.retrieve_card(card5)
          game.play_round(player2, card5.rank)
          round_result_expectations([card5])
          game.play_round(player1, 'A')
          round_result_expectations([card1])
        end
      end
    end
  end

  describe '#add_player' do
    before do
      players.each { |player| game.add_player(player) }
    end

    it 'adds a player to the game' do
      expect(game.players['Player 1']).to eq player1
    end

    it 'sets the turn to the first person to join' do
      expect(game.turn).to eq player1
    end
  end
end
