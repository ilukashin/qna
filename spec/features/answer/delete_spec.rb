require 'rails_helper'

feature 'Author can delete their answer', %q{
  As an authenticated user
  I'd like to delete answer if i'm an author of this answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }

  describe 'Authenticated user' do
    background { sign_in(user1) }

    scenario 'tries to delete their answer' do
      answer = create(:answer, question: question, author: user1)
      visit question_path(question)

      expect(page).to have_content answer.body
      click_on 'Delete answer'
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to delete others answer' do
      create(:answer, question: question, author: user2)
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to delete any answer' do
      create(:answer, question: question, author: user1)
      visit question_path(question)
      expect(page).to_not have_link 'Delete answer'
    end
  end
end
