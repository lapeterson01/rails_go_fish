class AddWinnersToGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :games, :winner, foreign_key: { to_table: :users }
  end
end
