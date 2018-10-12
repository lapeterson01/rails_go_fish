class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :number_of_players
      t.jsonb :data

      t.timestamps
    end
  end
end
