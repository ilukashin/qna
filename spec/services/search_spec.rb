require 'rails_helper'

RSpec.describe SearchService, elasticsearch: true do
  let!(:user) { create(:user) }

  before do
    @question1 = create(:question, title: 'some title', body: 'some text', author: user)
    @question2 = create(:question, title: 'new question title', body: 'some text', author: user)
    @question3 = create(:question, title: 'third question', body: 'unknown', author: user)
    @answer = create(:answer, question: @question3, body: 'some text')
    @comment = create(:comment, commentable: @question3, body: 'some text', author: user)
    Question.__elasticsearch__.create_index!
    Answer.__elasticsearch__.create_index!
    Comment.__elasticsearch__.create_index!
    Question.__elasticsearch__.refresh_index!
    Answer.__elasticsearch__.refresh_index!
    Comment.__elasticsearch__.refresh_index!
  end

  describe 'global search' do
    before do
      @results = SearchService.new.search('some text', "")
    end

    it 'returns array of results' do
      expect(@results).to be_an_instance_of(Array)
      expect(@results.size).to eq 4
    end

    it 'returns mapped data in result' do
      expect(@results[0][:title]).to eq(@question1.title)
      expect(@results[0][:details]).to eq(@question1.body)

      expect(@results[1][:title]).to eq(@question2.title)
      expect(@results[1][:details]).to eq(@question2.body)

      expect(@results[2][:title]).to eq(@answer.question.title)
      expect(@results[2][:details]).to eq(@answer.body)
    end
  end

  describe 'search only one model' do


    describe 'question' do
      before { @results = SearchService.new.search(@question2.title, "Question") }

      it 'should return only questions' do
        expect(@results[0][:title]).to eq(@question2.title)
        expect(@results[0][:details]).to eq(@question2.body)
      end
    end

    describe 'answer' do
      before { @results = SearchService.new.search(@answer.body, "Answer") }

      it 'should return only answers' do
        expect(@results[0][:title]).to eq(@answer.question.title)
        expect(@results[0][:details]).to eq(@answer.body)
      end
    end

    describe 'comment' do
      before { @results = SearchService.new.search(@comment.body, "Comment") }

      it 'should return only comments' do
        expect(@results[0][:title]).to eq(@comment.commentable.title)
        expect(@results[0][:details]).to eq(@comment.body)
      end
    end
  end



end
