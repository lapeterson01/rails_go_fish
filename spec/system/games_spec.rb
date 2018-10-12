require 'rails_helper'

RSpec.describe 'Games', type: :system do
  def signin
    visit root_url
    fill_in 'Username', with: test_user.username
    fill_in 'Password', with: test_user.password
    click_on 'Go!'
  end

  let(:test_user) do
    User.new name: 'Jermaine Thiel', username: 'ja_real_thiel', password: 'password',
             password_confirmation: 'password'
  end

  before do
    driven_by :rack_test
    test_user.save
  end

  it 'allows user to go to games lobby' do
    signin
    expect(page).to have_content 'Games'
    expect(page).to have_content 'Create Game'
  end
end
