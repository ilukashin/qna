shared_examples_for 'API authorizable' do

  context 'unauthorized' do
    it 'returns 401 if there is no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 if there is not valid' do
      do_request(method, api_path, params: { access_token: '12345' }, headers: headers)
      expect(response.status).to eq 401
    end
  end

end
