require 'rails_helper'

feature 'Author can delete their question', %q{
  As an authenticated user
  I'd like to delete question if i'm an author of this question
} do
  given(:users) { create_list(:user, 2) }

  describe 'Authenticated user' do
    given(:question1) { create(:question, author: users[0]) }
    given(:question2) { create(:question, author: users[1]) }
    background { sign_in(users[0]) }

    scenario 'tries to delete their question' do
      visit question_path(question1)
      click_on 'Delete question'
      expect(page).to have_content 'Successfully deleted question.'
    end

    scenario 'tries to delete others question' do
      visit question_path(question2)
      click_on 'Delete question'
      expect(page).to have_content 'Only author can delete this question.'
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question, author: users[1]) }
    background { visit question_path(question) }

    scenario 'tries to delete any question' do
      click_on 'Delete question'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
