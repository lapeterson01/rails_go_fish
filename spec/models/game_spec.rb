require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:go_fish) { GoFish.new }
  let(:test_game) { Game.new(name: 'test_game', number_of_players: 2, data: go_fish.start.as_json) }

  it 'should be valid' do
    expect(test_game).to be_valid
  end

  it 'should return a default name if name is left empty' do
    test_game = Game.new(number_of_players: 2, data: go_fish.start.as_json)
    test_game.save
    expect(test_game.name).to eq "Go Fish #{test_game.id}"
    test_game = Game.new(name: ' ', number_of_players: 2, data: go_fish.start.as_json)
    test_game.save
    expect(test_game.name).to eq "Go Fish #{test_game.id}"
  end
end
