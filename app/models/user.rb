class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :username, presence: true, length: { maximum: 30 },
                       uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
