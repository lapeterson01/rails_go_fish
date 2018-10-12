class Game < ApplicationRecord
  after_save do
    self.name = "Go Fish #{id}" if !name || name.split.empty?
  end

  has_many :game_users, dependent: :destroy
  has_many :users, -> { distinct }, through: :game_users

  validates :name, uniqueness: true
  validates :number_of_players, numericality: { less_than_or_equal_to: 4, only_integer: true }
end
