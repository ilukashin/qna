require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'DELETE #destroy' do
    before do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    context 'author of question' do
      before do
        login(user)
        delete :destroy, params: { id: question.files.first.id, format: :js }
      end

      it 'should delete attachment' do
        expect(question.files.reload).to be_empty
      end

      it 'should render destroy view' do
        expect(response).to render_template :destroy
      end
    end

    context 'not author of question' do
      let(:user2) { create(:user) }

      before do
        login(user2)
        delete :destroy, params: { id: question.files.first.id, format: :js }
      end

      it 'should not delete attachment' do
        expect(question.files.reload).to_not be_empty
      end
      it 'return status 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

end

