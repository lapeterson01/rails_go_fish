require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  def signup
    click_on 'Sign Up'
    fill_in 'Name', with: test_user[:name]
    fill_in 'Username', with: test_user[:username]
    fill_in 'Password', with: test_user[:password]
    fill_in 'Password Confirmation', with: test_user[:password]
    click_on 'Go!'
  end

  def signin
    fill_in 'Username', with: test_user[:username]
    fill_in 'Password', with: test_user[:password]
    click_on 'Go!'
  end

  def signout
    click_on 'Logout'
  end

  let(:test_user) { { name: 'Jermaine Thiel', username: 'ja_real_thiel', password: 'password' } }

  before do
    driven_by :rack_test
  end

  it 'shows signin page' do
    visit root_url
    expect(page).to have_content 'Go Fish!'
    expect(page).to have_content 'Login'
  end

  it 'allows user to signup' do
    visit root_url
    signup
    expect(page).to have_content 'Go Fish!'
    user = User.find_by(name: 'Jermaine Thiel', username: 'ja_real_thiel')
    expect(!!user.authenticate('password')).to eq true # rubocop:disable Style/DoubleNegation
  end

  it 'allows user to signin' do
    visit root_url
    signup
    signin
    expect(page).to have_content 'Games'
  end

  it 'allows user to signout' do
    visit root_url
    signup
    signin
    signout
    expect(page).to have_content 'Go Fish!'
  end

  it 'does not allow user to visit pages other than signin and signup pages when not logged in' do
    visit games_path
    expect(page).to have_content 'Login to continue'
  end

  it 'allows user to go to games lobby' do
    visit root_url
    signup
    signin
    expect(page).to have_content 'Games'
    expect(page).to have_content 'Create Game'
  end
end
