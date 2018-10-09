require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: 'Test User', username: 'testuser97')
  end

  it 'should be valid' do
    expect(@user).to be_valid
  end

  describe 'name' do
    it 'should not be empty' do
      @user.name = '   '
      expect(@user).to_not be_valid
    end

    it 'should not be too long' do
      @user.name = 'a' * 31
      expect(@user).to_not be_valid
    end
  end
end
