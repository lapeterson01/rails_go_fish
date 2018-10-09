class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games, &:timestamps
  end
end
