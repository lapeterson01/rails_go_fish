class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, -> { distinct }, through: :game_users

  validates :name, presence: true, length: { maximum: 30 }
  validates :username, presence: true, length: { maximum: 30 },
                       uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
