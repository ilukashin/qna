# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe 'GET#index' do
    let(:user) { create(:user) }

    before do
      login(user)
      get :index
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

end
