require 'rails_helper'

feature 'Select best answer', %q{
  In order to mark best answer
  As author of question
  I'd like to be able select best answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do

    context 'is author' do
      background do
        sign_in user
        visit question_path(question)
      end
      scenario 'can select best answer' do
        within "#answer-#{answer.id}" do
          click_on 'Choose best'
        end

        within '.best-answer' do
          expect(page).to have_content answer.body
        end
      end

      scenario 'can select another best answer' do
        within "#answer-#{answer.id}" do
          click_on 'Choose best'
        end
        within "#answer-#{answer2.id}" do
          click_on 'Choose best'
        end

        within '.best-answer' do
          expect(page).to_not have_content answer.body
          expect(page).to have_content answer2.body
        end
      end
    end

    context 'is not author' do
      background do
        sign_in user2
        visit question_path(question)
      end
      scenario 'can not select best answer' do
        expect(page).to_not have_link 'Choose best'
      end
    end

  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }
    scenario 'can not select best answer' do
      expect(page).to_not have_link 'Choose best'
    end
  end
end
