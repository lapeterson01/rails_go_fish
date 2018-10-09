require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  before do
    driven_by :rack_test
  end

  it 'shows signin page' do
    visit root_url
    expect(page).to have_content 'Go Fish!'
    expect(page).to have_content 'Please Enter Your Name'
  end

  it 'allows user to signin' do
    visit root_url
    fill_in 'Name', with: 'Test User'
    click_on 'Create User'
    expect(page).to have_content 'This is the lobby'
  end
end
