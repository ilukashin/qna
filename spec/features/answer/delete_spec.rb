require 'rails_helper'

feature 'Author can delete their answer', %q{
  As an authenticated user
  I'd like to delete answer if i'm an author of this answer
} do

  given(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, author: users[0]) }

  describe 'Authenticated user' do
    background { sign_in(users[0]) }

    scenario 'tries to delete their answer' do
      create(:answer, question: question, author: users[0])
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to have_content 'Successfully deleted answer.'
    end

    scenario 'tries to delete others answer' do
      create(:answer, question: question, author: users[1])
      visit question_path(question)
      click_on 'Delete answer'
      expect(page).to have_content 'Only author can delete this answer.'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete any answer' do
      create(:answer, question: question, author: users[0])
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
