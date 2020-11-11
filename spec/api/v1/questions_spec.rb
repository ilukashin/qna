require 'rails_helper'

describe 'Questions api', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe "GET /api/v1/questions" do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of question' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answer' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe "GET /api/v1/questions/:id" do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question, author: create(:user)) }
      let!(:links) { create_list(:link, 2, linkable: question) }

      let!(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper1.rb')
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper2.rb')

        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      it 'contains answers object' do
        expect(question_response['answers'].count).to eq 2
      end

      it 'contains links object' do
        expect(question_response['links'].count).to eq 2
      end

      it 'contains comments object' do
        expect(question_response['comments'].count).to eq 2
      end

      it 'contains attachments object' do
        expect(question_response['files'].count).to eq 2
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:creatable) { :question }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API deletable' do
      let(:deletable) { :question }
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API updatable' do
      let(:updatable) { :question }
    end
  end

end
