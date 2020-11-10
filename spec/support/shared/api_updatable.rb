shared_examples_for 'API updatable' do
  context 'authorized user' do
    context 'author tries to update' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid data' do
        let(:updatable_response) { json[updatable.to_s] }
        before do
          do_request :patch, api_path, params: {
              access_token: access_token.token,
              updatable => { body: 'new body' }
          }, headers: headers
        end

        it 'returns 200 status' do
          expect(response.status).to eq 200
        end

        it 'return object' do
          expect(json).to have_key updatable.to_s
        end

        it 'change updatable attributes in db' do
          expect(send(updatable).reload.body).to eq 'new body'
        end

        it 'should return objects public fields' do
          expect(updatable_response['id']).to eq updatable.to_s.capitalize.constantize.last.id
          expect(updatable_response['body']).to eq 'new body'
          expect(updatable_response).to have_key 'created_at'
          expect(updatable_response).to have_key 'updated_at'
          expect(updatable_response['author']['id']).to eq user.id
        end
      end

      context 'with invalid data' do
        before do
          do_request :patch, api_path, params: {
              access_token: access_token.token,
              updatable => { body: '' }
          }, headers: headers
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end

        it 'does not change updatable attributes in db' do
          expect(send(updatable).reload.body).to_not eq ''
        end
      end
    end

    context 'not an author' do
      let!(:access_token) { create(:access_token, resource_owner_id: create(:user).id) }

      before do
        do_request :patch, api_path, params: {
            access_token: access_token.token,
            updatable => { body: 'new body' }
        }, headers: headers
      end

      it 'returns 403 status' do
        expect(response.status).to eq 403
      end

      it 'does not change updatable attributes in db' do
        expect(send(updatable).reload.body).to_not eq 'new body'
      end
    end
  end
end
