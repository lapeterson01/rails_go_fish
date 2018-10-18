require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:go_fish) { GoFish.new }
  let(:test_game) do
    Game.new(name: 'test_game', number_of_players: 2, data: go_fish.start.as_json, host: 1)
  end

  it 'should be valid' do
    expect(test_game).to be_valid
  end

  describe 'name' do
    it 'should return a default name if name is left empty' do
      test_game.name = ' '
      test_game.save
      expect(test_game.name).to eq "Go Fish #{test_game.id}"
      test_game2 = Game.new(number_of_players: 2, data: go_fish.start.as_json, host: 2)
      test_game2.save
      expect(test_game2.name).to eq "Go Fish #{test_game2.id}"
    end

    it 'must be unique' do
      duplicate_test_game = test_game.dup
      test_game.save
      expect(duplicate_test_game).to_not be_valid
    end
  end

  describe 'number_of_players' do
    it 'should only allow a max number of players' do
      test_game.number_of_players = 5
      expect(test_game).to_not be_valid
    end

    it 'should only allow a min number of players' do
      test_game.number_of_players = 1
      expect(test_game).to_not be_valid
    end
  end

  describe 'host' do
    it 'should be present' do
      test_game.host = nil
      expect(test_game).to_not be_valid
    end
  end
end
