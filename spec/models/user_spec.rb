require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new name: 'Test User', username: 'testuser97', password: 'foobar',
                     password_confirmation: 'foobar'
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

  describe 'username' do
    it 'should not be empty' do
      @user.username = '    '
      expect(@user).to_not be_valid
    end

    it 'should not be too long' do
      @user.username = 'a' * 31
      expect(@user).to_not be_valid
    end

    it 'should be unique' do
      duplicate_user = @user.dup
      duplicate_user.username = @user.username.upcase
      @user.save
      expect(duplicate_user).to_not be_valid
      @user.destroy
    end
  end

  describe 'password' do
    it 'should not be blank' do
      @user.password = @user.password_confirmation = '      '
      expect(@user).to_not be_valid
    end

    it 'should not be too short' do
      @user.password = @user.password_confirmation = 'a' * 5
      expect(@user).to_not be_valid
    end
  end
end
