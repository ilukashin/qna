shared_examples_for 'API deletable' do

  context 'authorized user' do
    context 'author tries to delete' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'should delete object from db' do
        expect {
          delete api_path,
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(deletable.to_s.capitalize.constantize, :count).by(-1)
      end

      it 'should return 200 status' do
        delete api_path, params: { access_token: access_token.token }, headers: headers

        expect(response.status).to eq 200
      end
    end

    context 'not an author' do
      let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      it 'returns 403 status' do
        do_request :patch, api_path, params: {
          access_token: access_token.token,
          deletable => { body: 'new body' }
        }, headers: headers

        expect(response.status).to eq 403
      end

      it 'does not delete object' do
        expect {
          do_request :patch, api_path, params: {
            access_token: access_token.token,
            deletable => { body: 'new body' }
          }, headers: headers
        }.to_not change(deletable.to_s.capitalize.constantize, :count)
      end
    end
  end
end
