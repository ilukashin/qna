shared_examples_for 'API deletable' do
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
