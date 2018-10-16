class Game < ApplicationRecord
  after_save do
    self.name = "Go Fish #{id}" if !name || name.split.empty?
  end

  has_many :game_users, dependent: :destroy
  has_many :users, -> { distinct }, through: :game_users

  validates :name, uniqueness: true
  validates :number_of_players, numericality: {
    less_than_or_equal_to: 4,
    greater_than_or_equal_to: 2,
    only_integer: true
  }

  def players
    data['players'].map { |player| player['name'] }
  end

  def add_player_to_game(user)
    go_fish = data ? GoFish.from_json(data) : GoFish.new
    go_fish.add_player(Player.new(user.id, user.name))
    self.data = go_fish.as_json
    save
    users << user
  end
end
