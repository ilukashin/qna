require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:test_link) { create(:link, linkable: question) }
  before { question.links << test_link }

  describe 'DELETE #destroy' do
    context 'an author of linkable' do
      before do
        login(user)
        delete :destroy, params: { id: question.links.first.id, format: :js }
      end

      it 'should delete link' do
        expect(question.links.reload).to be_empty
      end

      it 'should render destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'not an author of linkable' do
      let(:user2) { create(:user) }

      before do
        login(user2)
        delete :destroy, params: { id: question.links.first.id, format: :js }
      end

      it 'should not delete link' do
        expect(question.links.reload).to_not be_empty
      end
      it 'return status 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end

