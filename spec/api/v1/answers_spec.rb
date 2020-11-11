require 'rails_helper'

describe 'Answers api', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question, author: user) }
  let(:answer) { answers.first }

  describe "GET /api/v1/questions/:id/answers" do
    let!(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answers'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at links author].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer, author: user) }
    let(:api_path) { "/api/v1//answers/#{answer.id}" }

    before do
      answer.files.attach(io: File.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper1.rb')
      answer.files.attach(io: File.new("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper2.rb')
    end

    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'should return 200 status' do
        expect(response).to be_successful
      end

      it 'return all public fields of answer' do
        %w[id body question_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.author.id
      end

      it 'contains comments object' do
        expect(answer_response['comments'].count).to eq 2
      end

      it 'contains links object' do
        expect(answer_response['links'].count).to eq 2
      end

      it 'contains attachments object' do
        expect(answer_response['files'].count).to eq 2
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API creatable' do
      let(:creatable) { :answer }
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :delete }
    end

    it_behaves_like 'API deletable' do
      let(:deletable) { :answer }
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authorizable' do
      let(:method) { :patch }
    end

    it_behaves_like 'API updatable' do
      let(:updatable) { :answer }
    end
  end


end
