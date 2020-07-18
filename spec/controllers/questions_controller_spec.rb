# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question, author: user) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders #show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders #new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'Authenticated user tries to create question' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end
        it 'set user as author' do
          question = create(:question, author: user)
          expect(user).to be_author_of(question)
        end
        it 'redirect to #show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid params' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end
        it 're-render #new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'Unauthenticated user tries to create question' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end
      it 'redirect to login page' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before { login(user) }

      context 'is author' do
        let!(:question) { create(:question, author: user) }

        it 'can delete the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end
        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'is not author' do
        let(:user2) { create(:user) }
        let!(:question) { create(:question, author: user2) }

        it 'can not delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to question_path(question)
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:question) { create(:question, author: user) }

      it 'can not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      it 'redirects to login page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, author: user) }

    describe 'author updates' do
      before { login(user) }

      context 'with valid attributes' do
        it 'change question attributes' do
          patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
          question.reload
          expect(question.body).to eq 'new body'
        end

        it 'render update view' do
          patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid params' do
        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          end.to_not change(question, :body)
        end

        it 'render update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    describe 'not author updates' do
      let(:user2) { create(:user) }
      before { login(user2) }

      it 'should not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
        end.to_not change(question, :body)
      end
      it 'return status 403' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
