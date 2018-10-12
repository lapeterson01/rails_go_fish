class Game < ApplicationRecord
  after_save do
    self.name = "Go Fish #{self.id}" if !name || name.split.empty?
  end

  has_many :game_users, dependent: :destroy
  has_many :users, -> { distinct }, through: :game_users
end
