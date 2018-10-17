# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_017_212_949) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'game_users', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'game_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['game_id'], name: 'index_game_users_on_game_id'
    t.index ['user_id'], name: 'index_game_users_on_user_id'
  end

  create_table 'games', force: :cascade do |t|
    t.string 'name'
    t.integer 'number_of_players'
    t.jsonb 'data'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'host'
    t.bigint 'winner_id'
    t.index ['winner_id'], name: 'index_games_on_winner_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'username'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'password_digest'
  end

  add_foreign_key 'game_users', 'games'
  add_foreign_key 'game_users', 'users'
  add_foreign_key 'games', 'users', column: 'winner_id'
end
