require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:rewards) }
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'User#author_of?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user1) }

    it 'returns true if user is author of record' do
      expect(user1).to be_author_of(question)
    end

    it 'returns false if user is not author of record' do
      expect(user2).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) {create(:user)}
    let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456')}
    let(:service) { double('FindFOrOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

end
