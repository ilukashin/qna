require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #show' do
    let(:answer) { create(:answer, question: question, author: user) }

    before { get :show, params: { id: answer } }

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders #show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders #new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Authenticated user tries to create answer' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, author: user } }.to change(Answer, :count).by(1)
        end
        it 'redirect to #show view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid params' do
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
        end
        it 're-render #new view' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'Unauthenticated user tries to create answer' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to_not change(Answer, :count)
      end
      it 'redirect to login page' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:question) { create(:question, author: user) }

    context 'Authenticated user' do
      before { login(user) }

      context 'is author' do
        let!(:answer) { create(:answer, question: question, author: user) }

        it 'can delete the answer' do
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end
        it 'redirects to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'is not author' do
        let(:user2) { create(:user) }
        let!(:answer) { create(:answer, question: question, author: user2) }

        it 'can not delete the answer' do
          expect { delete :destroy, params: { id: answer } }.to_not change(Question, :count)
        end
        it 'redirects to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'can not delete the question' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Question, :count)
      end
      it 'redirects to login page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
