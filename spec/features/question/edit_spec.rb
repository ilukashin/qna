require 'rails_helper'

feature 'User can edit question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'User can not edit question' do
    scenario 'if unauthenticated', js: true do
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end

    scenario 'if not an author of question' do
      sign_in user2
      visit question_path(question)
      expect(page).to_not have_link 'Edit question'
    end
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'can edit his answer' do
      within '.question' do
        fill_in 'Body', with: 'edited question'
        click_on 'Update Question'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question'
        expect(page).to_not have_selector 'textarea'
      end

    end

    scenario 'tries edit his question with errors' do
      within '.question' do
        fill_in 'Body', with: ''
        click_on 'Update Question'

        expect(page).to have_content question.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end
  end
end
