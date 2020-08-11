require 'rails_helper'

shared_examples_for 'voted' do
  let(:described_model) { create(described_class.controller_name.classify.downcase.to_sym) }

  describe 'PATCH #up' do
    before { patch :up, params: { id: described_model }, format: :json }

    it 'send json response' do
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end

  describe 'PATCH #down' do
    before { patch :down, params: { id: described_model }, format: :json }

    it 'send json response' do
      expect(response.header['Content-Type']).to include 'application/json'
    end
  end
end
