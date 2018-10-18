require 'rails_helper'

RSpec.describe GameUser, type: :model do
  let(:go_fish) { GoFish.new }
  let(:test_game) do
    Game.new(name: 'test_game', number_of_players: 2, data: go_fish.as_json, host: 1)
  end
  let(:test_user) do
    User.new name: 'Jermaine Thiel', username: 'ja_real_thiel', password: 'password',
             password_confirmation: 'password'
  end

  it 'should contain a user and game id' do
    test_game.save
    test_user.save
    test_user.games << test_game
    expect(test_user.games.first).to eq test_game
    expect(test_game.users.first).to eq test_user
  end
end
