require 'rails_helper'

RSpec.describe User, type: :model do
  # subject(:user) {FactoryBot.build(:user)}
  subject(:user) {User.create(username: 'John', password: 'password')}
  # before(:each) { subject(:user) {User.create(username: 'John', password: 'password')} }

  describe 'validations' do
    it { validate_presence_of(:username) }
    it { validate_presence_of(:password_digest) }
    it { validate_presence_of(:session_token) }

    it { validate_uniqueness_of(:username) }
    it { validate_uniqueness_of(:password_digest) }
    it { validate_uniqueness_of(:session_token) }

    it { validate_length_of(:password).is_at_least(6)}
  end
  
  describe 'password encryption' do 
    it 'encrypts the password' do
      expect(BCrypt::Password).to receive(:create).with('123456')
      User.new(username: 'Jenny', password: '123456')
    end

    it 'does not persist passwords to the database' do
      user.save!
      user2 = User.find_by(username: user.username)
      expect(user2.password).to be_nil
    end
  end

  describe '#ensure_session_token' do
    it 'automatically sets the session token' do
      expect(user.session_token).not_to be_nil
    end
  end

  describe '::find_by_credentials' do
    context 'valid user' do
      it 'finds user and verifies if password matches' do
        user3 = user
        expect(user3.password).to eq('password')
        expect(user3).to be(user)
      end
    end
    
    context 'invalid user' do
      it 'does not find user or password does not match returns nil' do
        user4 = User.create(username: 'Jane', password: 'password')
        user5 = User.find_by(username: 'Sarah')
        expect(user5).to be_nil
      end
    end
  end
  
end
