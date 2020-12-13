require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    let(:user) { create(:user) }
    let(:question) { create(:question, title: 'some title', body: 'some text', author: user) }

    before { get :search, params: { search: { query: 'some text' } } }

    it 'assign results to @results' do
      expect(assigns(:results)).to be_an_instance_of(Array)
    end

    it 'renders results view' do
      expect(response).to render_template :results
    end
  end

end
