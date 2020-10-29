require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

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
          expect { post :create, params: { answer: attributes_for(:answer), format: :js, question_id: question} }.to change(question.answers, :count).by(1)
        end
        it 'set user as author' do
          answer = create(:answer, question: question, author: user)
          expect(user).to be_author_of(answer)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer), format: :js, question_id: question }
          expect(response).to render_template :create
        end
      end

      context 'with invalid params' do
        it 'does not save the answer' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
        end
        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), format: :js, question_id: question }
          expect(response).to render_template :create
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
    context 'Authenticated user' do
      before { login(user) }

      context 'is author' do
        let!(:answer) { create(:answer, question: question, author: user) }

        it 'can delete the answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end
        it 'redirects to question' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'Unauthenticated user' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'can not delete the question' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Question, :count)
      end
      it 'redirects to login page' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response.status).to be(401)
        expect(response.body).to have_content('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, author: user)}

    describe 'author updates' do
      before { login(user) }

      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'render update view' do
          patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid params' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          end.to_not change(answer, :body)
        end

        it 'render update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end
  end

  describe 'POST #best' do
    let!(:answer) { create(:answer, question: question, author: user) }
    let!(:answer2) { create(:answer, question: question, author: user) }

    context 'author of question choose best answer' do
      before { login(user) }
      it 'marks answer as best' do
        post :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer).to be_is_best
      end

      it 'only one answer can be best' do
        post :best, params: { id: answer, format: :js }
        post :best, params: { id: answer2, format: :js }
        answer2.reload
        expect(answer2).to be_is_best
        expect(answer).to_not be_is_best
      end

      it 'render best view' do
        post :best, params: { id: answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'not author of question' do
      let(:user2) { create(:user) }
      before { login(user) }

      it 'cant choose best answer' do
        post :best, params: { id: answer, format: :js }
        expect(answer).to_not be_is_best
      end
    end

    context 'unauthenticated user' do
      it 'cant choose best answer' do
        post :best, params: { id: answer, format: :js }
        expect(answer).to_not be_is_best
      end
    end
  end

end
