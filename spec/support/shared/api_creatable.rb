shared_examples_for 'API creatable' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'valid data' do
      let(:creatable_response) { json[creatable.to_s] }
      before do
        post api_path,
             params: { creatable => { title: 'test title', body: 'test body' }, access_token: access_token.token },
             headers: headers
      end

      it 'returns :created status' do
        expect(response.status).to eq 201
      end

      it 'should create new object' do
        expect {
          post api_path,
               params: { creatable => { title: 'test title', body: 'test body' }, access_token: access_token.token },
               headers: headers
        }.to change(creatable.to_s.capitalize.constantize, :count).by(1)
      end

      it 'should return objects public fields' do
        expect(creatable_response['id']).to eq creatable.to_s.capitalize.constantize.last.id
        expect(creatable_response['body']).to eq 'test body'
        expect(creatable_response).to have_key 'created_at'
        expect(creatable_response).to have_key 'updated_at'
        expect(creatable_response['author']['id']).to eq user.id
      end
    end

    context 'invalid data' do
      before do
        post api_path, params: { creatable => { body: nil }, access_token: access_token.token }, headers: headers
      end

      it 'returns 422 status' do
        expect(response.status).to eq 422
      end

      it 'should not create new object' do
        expect {
          post api_path,
               params: { creatable => { title: nil, body: nil }, access_token: access_token.token },
               headers: headers
        }.to_not change(creatable.to_s.capitalize.constantize, :count)
      end

      it 'should return error message' do
        expect(json['errors']).to include("Body can't be blank")
      end
    end
  end
end
