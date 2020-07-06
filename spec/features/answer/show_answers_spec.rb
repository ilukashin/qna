require 'rails_helper'

feature 'show all answers to the question', %q{
  In order to find answers for exist question
  As user
  I'd like to see all answers to current question
} do

  let(:user) { create(:user) }

  describe 'if question have some answers' do
    given!(:question) { create(:question, author: user) }
    given!(:answers) { create_list(:answer, 3, question: question, author: user) }
    before { visit question_path(question) }

    scenario 'user got all answers to current question' do
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end

  describe 'if question do not have answers' do
    given!(:question) { create(:question, author: user) }
    before { visit question_path(question) }

    scenario 'user got message' do
      expect(page).to have_content 'No answers for this question.'
    end
  end

end
