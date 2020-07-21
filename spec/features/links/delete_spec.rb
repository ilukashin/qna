require 'rails_helper'

feature 'User can delete links', %q{
  In order to correct mistakes
  As an author
  I'd like to be able to remove links
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:test_link) { create(:link, linkable: question) }
  given!(:test_link2) { create(:link, linkable: answer) }
  background do
    question.links << test_link
    answer.links << test_link2
  end

  describe 'Authenticated user', js: true do

    describe 'an author' do
      background do
        sign_in user
        visit question_path(question)
      end

      scenario 'can delete link form question' do
        within '.question' do
          click_on 'Delete link'
          expect(page).to_not have_link question.links.first.name
        end
      end

      scenario 'can delete link form answer' do
        within '.answers' do
          click_on 'Delete link'
          expect(page).to_not have_link answer.links.first.name
        end
      end
    end

    describe 'not an author' do
      background do
        sign_in user2
        visit question_path(question)
      end

      scenario 'can not delete link form question' do
        within '.question' do
          expect(page).to_not have_link 'Delete link'
        end
      end

      scenario 'can not delete link form answer' do
        within '.answers' do
          expect(page).to_not have_link 'Delete link'
        end
      end
    end

  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end

    scenario 'can not delete link form question' do
      within '.question' do
        expect(page).to_not have_link 'Delete link'
      end
    end

    scenario 'can not delete link form answer' do
      within '.answers' do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end
end
