require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe 'POST#Create' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }

    context 'authorized user' do
      before { login(user) }

      it 'creates new subscription' do
        expect { post :create, params: { question_id: question }, format: :json }.to change(Subscription, :count).by(1)
      end

      it 'does not redirected' do
        post :create, params: { question_id: question }, format: :json
        expect(response.status).to_not eq 302
      end

      it 'does not create new subscription if already have' do
        expect do
          post :create, params: { question_id: question }, format: :json
          post :create, params: { question_id: question }, format: :json
        end.to change(Subscription, :count).by(1)
      end
    end

    context 'unauthorized user' do
      it 'does not create new subscription' do
        expect { post :create, params: { question_id: question } }.to_not change(Subscription, :count)
      end
    end
  end

  describe 'DELETE#Destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'authorized user' do
      before { login(user) }

      context 'already have subscription' do
        it 'cancels subscription' do
          expect { delete :destroy, params: { id: subscription }, format: :json }.to change(Subscription, :count).by(-1)
        end

        it 'does not redirected' do
          delete :destroy, params: { id: subscription }, format: :json
          expect(response.status).to_not eq 302
        end
      end
    end

    context 'unauthorized user' do
      it 'does not delete subscription' do
        expect { delete :destroy, params: { id: subscription } }.to_not change(Subscription, :count)
      end
    end
  end

end
