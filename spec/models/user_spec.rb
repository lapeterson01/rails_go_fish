require 'rails_helper'

RSpec.describe User, type: :model do
  let(:test_user) do
    User.new name: 'Jermaine Thiel', username: 'ja_real_thiel', password: 'password',
             password_confirmation: 'password'
  end

  it 'should be valid' do
    expect(test_user).to be_valid
  end

  describe 'name' do
    it 'should not be empty' do
      test_user.name = '   '
      expect(test_user).to_not be_valid
    end

    it 'should not be too long' do
      test_user.name = 'a' * 31
      expect(test_user).to_not be_valid
    end
  end

  describe 'username' do
    it 'should not be empty' do
      test_user.username = '    '
      expect(test_user).to_not be_valid
    end

    it 'should not be too long' do
      test_user.username = 'a' * 31
      expect(test_user).to_not be_valid
    end

    it 'should be unique' do
      duplicate_test_user = test_user.dup
      duplicate_test_user.username = test_user.username.upcase
      test_user.save
      expect(duplicate_test_user).to_not be_valid
    end
  end

  describe 'password' do
    it 'should not be empty' do
      test_user.password = '    '
      test_user.password_confirmation = '    '
      expect(test_user).to_not be_valid
    end

    it 'should not be too short' do
      test_user.password = 'a' * 5
      test_user.password_confirmation = 'a' * 5
      expect(test_user).to_not be_valid
    end
  end
end
