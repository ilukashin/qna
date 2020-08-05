# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  describe 'GET#index' do

    before { get :index }

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

end
