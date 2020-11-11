require 'rails_helper'

describe 'Profiles api', type: :request do
  let(:headers) {
    { 'CONTENT-TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user, admin: true) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        expect(json['user']).to match_json_schema("v1/user")
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 2) }
      let!(:access_token) { create(:access_token) }
      let!(:user) { users.first }
      let(:user_response) { json['users'].first }
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users' do
        expect(json['users'].size).to eq 2
      end

      it 'returns all public fields' do
        expect(user_response).to match_json_schema("v1/users")
      end
    end
  end
end
