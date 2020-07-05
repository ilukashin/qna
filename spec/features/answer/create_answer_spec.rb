require 'rails_helper'

feature 'add an answer to question', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to leave my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add their answer to question' do
      fill_in 'Body', with: 'Custom answer'
      click_on 'Answer'
      expect(page).to have_content 'Custom answer'
    end

    scenario 'add their answer with wrong params to question' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end
    scenario 'tries to add his answer' do
      fill_in 'Body', with: 'Custom answer'
      click_on 'Answer'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
