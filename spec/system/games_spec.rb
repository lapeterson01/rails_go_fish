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

  def play_round(rank)
    session1.click_on rank
    session1.click_on(class: 'opponent')
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

    it 'allows players to play a round' do
      initiate_game
      play_round('J')
      expect(session1 && session2).to have_content('Cards: 8') && have_content('Cards: 6')
      expect(session1).to have_content "You took J of Clubs from #{test_user2.name}"
      expect(session2).to have_content "#{test_user.name} took J of Clubs from you"
    end

    it 'allows player to get a book' do
      initiate_game
      play_round('A')
      expect(session1 && session2).to have_content('Cards: 5', count: 2)
      expect(session1).to have_content 'You got a book!'
      expect(session2).to have_content "#{test_user.name} got a book!"
    end
  end
end
