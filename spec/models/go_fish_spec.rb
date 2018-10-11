require 'rails_helper'

class TestDeck
  attr_reader :cards

  RANKS = %w[A K Q J].freeze
  SUITS = %w[Spades Clubs Diamonds Hearts].freeze

  def initialize
    @cards = RANKS.map { |rank| SUITS.map { |suit| PlayingCard.new(rank, suit) } }.flatten
  end

  def shuffle!
    # do nothing
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
end

RSpec.describe GoFish, type: :model do
  # rubocop:disable Metrics/AbcSize
  def round_result_expectations(cards, round_result = go_fish.round_result)
    expect(round_result[:card_from]).to eq go_fish.player
    expect(round_result[:cards]).to eq cards
    expect(round_result[:rank_asked_for]).to eq go_fish.rank
    expect(round_result[:turn]).to eq go_fish.turn
    yield if block_given?
  end
  # rubocop:enable Metrics/AbcSize

  let(:go_fish) { GoFish.new }
  let(:player1) { Player.new('Player 1') }
  let(:player2) { Player.new('Player 2') }
  let(:players) { [player1, player2] }

  describe '#initialize' do
    it 'begins with deck of 52 standard playing cards' do
      expect(go_fish.deck).to eq CardDeck.new
    end

    it 'begins with empty players hash' do
      expect(go_fish.players).to eq({})
    end
  end

  describe 'go_fishplay' do
    let(:card1) { PlayingCard.new('A', 'Spades') }
    let(:card2) { PlayingCard.new('A', 'Clubs') }

    before do
      players.each { |player| go_fish.add_player(player) }
    end

    describe '#start' do
      it 'shuffles the deck' do
        deck = CardDeck.new
        expect(go_fish.deck).to eq deck
        go_fish.start
        14.times { deck.deal }
        expect(go_fish.deck).to_not eq deck
      end

      it 'deals deck to players' do
        go_fish.start
        expect(go_fish.deck.cards.length).to eq 38
        expect(player1.count_hand && player2.count_hand).to eq 7
      end
    end

    describe '#play_round' do
      before do
        player1.retrieve_card(card1)
        player2.retrieve_card(card2)
      end

      describe '#set_player_and_rank' do
        it 'sets player and rank' do
          go_fish.set_player_and_rank(player2, card2.rank)
          expect(go_fish.player).to eq player2
          expect(go_fish.rank).to eq card2.rank
        end
      end

      describe '#player_has_card' do
        it 'takes card from player if player has card and returns true (turn got catch)' do
          go_fish.set_player_and_rank(player2, card2.rank)
          go_fish.player_has_card
          expect(go_fish.get_catch).to eq true
          expect(player1.count_hand).to eq 2
          expect(player2.count_hand).to eq 0
        end
      end

      describe '#go_fish' do
        it 'takes card from deck and gives it to turn and returns false (turn did not get catch)' do
          go_fish.set_player_and_rank(player2, 'Q')
          go_fish.go_fish
          expect(go_fish.get_catch).to eq false
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
          go_fish.set_player_and_rank(player2, 'A')
          go_fish.player_has_card
          go_fish.calculate_books
          expect(player1.count_hand).to eq 0
          expect(player1.books).to eq 1
        end
      end

      describe '#next_turn' do
        it 'goes to the next turn' do
          go_fish.next_turn
          expect(go_fish.turn).to eq player2
          go_fish.next_turn
          expect(go_fish.turn).to eq player1
        end
      end

      describe '#round_result' do
        let(:card3) { PlayingCard.new('A', 'Diamonds') }
        let(:card4) { PlayingCard.new('A', 'Hearts') }
        let(:card5) { PlayingCard.new('Q', 'Hearts') }

        it 'creates a hash to return with the results of the round' do
          [card3, card4].each { |card| player2.retrieve_card(card) }
          go_fish.set_player_and_rank(player2, 'A')
          go_fish.player_has_card
          go_fish.calculate_books
          round_result_expectations([card2, card3, card4]) do
            expect(go_fish.round_result[:books]).to eq 1
          end
        end

        it 'resets on next player turn' do
          player2.retrieve_card(card5)
          go_fish.play_round(player2, card5.rank)
          round_result_expectations([card5])
          go_fish.play_round(player1, 'A')
          round_result_expectations([card1])
        end
      end
    end

    describe '#winner' do
      let(:go_fish) { GoFish.new(TestDeck.new) }

      before do
        players.each { |player| go_fish.add_player(player) }
      end

      it 'assigns a winner when the pool is out of cards' do
        go_fish.start
        go_fish.play_round(player2, 'A')
        expect(go_fish.winner).to eq nil
        players.reverse_each { |player| go_fish.play_round(player, '2') }
        expect(go_fish.winner).to eq [player1]
      end

      it 'assigns a winner when a player is out of cards' do
        player1.retrieve_card(card1)
        player2.retrieve_card(card2)
        %w[Diamonds Hearts].each { |suit| player1.retrieve_card(PlayingCard.new('A', suit)) }
        go_fish.play_round(player2, 'A')
        expect(go_fish.winner).to eq [player1]
      end

      it 'assigns multiple winners if there is a tie' do
        go_fish.start
        players.reverse_each { |player| go_fish.play_round(player, '2') }
        expect(go_fish.winner).to eq [player1, player2]
      end
    end
  end

  describe '#add_player' do
    before do
      players.each { |player| go_fish.add_player(player) }
    end

    it 'adds a player to the go_fish' do
      expect(go_fish.players['Player 1']).to eq player1
    end

    it 'sets the turn to the first person to join' do
      expect(go_fish.turn).to eq player1
    end
  end
end
