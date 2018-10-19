require 'rails_helper'

RSpec.describe 'Games', type: :system do
  def signin(sessions)
    sessions.each do |session|
      session.visit root_url
      session.fill_in 'Username', with: test_users[sessions.index(session)].username
      session.fill_in 'Password', with: test_users[sessions.index(session)].password
      session.click_on 'Go!'
    end
  end

  def create_game
    session1.click_on 'Create Game'
    session1.fill_in 'Name', with: game_name
    session1.select 2
    session1.click_on 'Go!'
  end

  def join_game
    session2.driver.refresh
    session2.click_on game_name
    session2.click_on 'Join'
  end

  def start_game
    session1.click_on game_name
    session1.click_on 'Start Game'
  end

  def initiate_game
    signin(sessions)
    create_game
    join_game
    start_game
    session2.driver.refresh
  end

  def initiate_game_with_test_deck
    signin(sessions)
    go_fish = GoFish.new(TestDeck.new)
    test_users.each { |test_user| go_fish.add_player(Player.new(test_user)) }
    go_fish.start
    game = Game.new(number_of_players: 2, data: go_fish.as_json, host: test_user.id)
    game.save
    sessions.each { |session| session.visit game_url(game.id) }
  end

  def play_round(player_id, rank)
    session1.choose("card_#{rank}")
    session1.choose("player_#{player_id}")
    session1.click_on 'Play!'
    session2.driver.refresh
  end

  let(:test_user) do
    User.new name: 'Jermaine Thiel', username: 'ja_real_thiel', password: 'password',
             password_confirmation: 'password'
  end
  let(:test_user2) do
    User.new name: 'Fake User', username: 'fake_user', password: 'password',
             password_confirmation: 'password'
  end
  let(:test_users) { [] }
  let(:game_name) { 'test_game' }
  let(:session1) { Capybara::Session.new(:rack_test, Rails.application) }
  let(:sessions) { [] }

  before do
    driven_by :rack_test
    test_user.save
    test_user2.save
    sessions << session1
    test_users << test_user << test_user2
  end

  it 'allows user to go to games lobby' do
    signin(sessions)
    expect(session1).to have_content 'Games'
    expect(session1).to have_content 'Create Game'
  end

  it 'allows a user to visit new game page' do
    signin(sessions)
    session1.click_on 'Create Game'
    expect(session1).to have_content 'Create Game'
  end

  it 'allows a user to visit the game lobby' do
    signin(sessions)
    create_game
    session1.click_on game_name
    expect(session1).to have_content 'Players:'
    expect(session1).to have_content 'Jermaine Thiel'
  end

  describe 'two users' do
    let(:session2) { Capybara::Session.new(:rack_test, Rails.application) }

    before do
      sessions << session2
    end

    it 'allows a user to join a game' do
      signin(sessions)
      create_game
      join_game
      session1.click_on game_name
      expect(session1 && session2).to have_content 'Jermaine Thiel'
      expect(session1 && session2).to have_content 'Fake User'
    end

    it 'allows the host to start the game' do
      initiate_game
      expect(session1 && session2).to have_content 'Cards: 7'
      expect(session1 && session2).to have_content 'Books: 0'
    end

    describe 'gameplay' do
      let(:player1) { Player.new(test_user) }
      let(:player2) { Player.new(test_user2) }

      before do
        initiate_game_with_test_deck
      end

      it 'allows players to play a round' do
        play_round(player2.id, 'J')
        expect(session1 && session2).to have_content('Cards: 8') && have_content('Cards: 6')
        expect(session1).to have_content "You took J of Clubs from #{test_user2.name}"
        expect(session2).to have_content "#{test_user.name} took J of Clubs from you"
      end

      it 'allows player to get a book' do
        play_round(player2.id, 'A')
        expect(session1 && session2).to have_content('Cards: 5', count: 2)
        expect(session1).to have_content 'You got a book!'
        expect(session2).to have_content "#{test_user.name} got a book!"
      end

      it 'allows a player to win' do
        %w[A K Q J].each do |rank|
          play_round(player2.id, rank)
        end
        session2.driver.refresh
        expect(session1 && session2).to have_content 'Game Over'
        expect(session1 && session2).to have_content "Winner: #{test_user.name}"
      end
    end
  end
end
