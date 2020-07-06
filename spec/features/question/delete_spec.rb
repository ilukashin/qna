require 'rails_helper'

feature 'Author can delete their question', %q{
  As an authenticated user
  I'd like to delete question if i'm an author of this question
} do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  describe 'Authenticated user' do
    given(:question1) { create(:question, author: user1) }
    given(:question2) { create(:question, author: user2) }
    background { sign_in(user1) }

    scenario 'tries to delete their question' do
      visit question_path(question1)
      click_on 'Delete question'
      expect(page).to_not have_content question1.title
    end

    scenario 'tries to delete others question' do
      visit question_path(question2)
      expect(page).to_not have_link 'Delete question'
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question, author: user2) }
    background { visit question_path(question) }

    scenario 'tries to delete any question' do
      expect(page).to_not have_link 'Delete question'
    end
  end
end
