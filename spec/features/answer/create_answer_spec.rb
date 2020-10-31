require 'rails_helper'

feature 'add an answer to question', %q{
  In order to answer the question
  As an authenticated user
  I'd like to be able to leave my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add their answer to question' do
      within '.new-answer' do
        fill_in 'Body', with: 'Custom answer'
        click_on 'Answer'
      end
      expect(page).to have_content 'Custom answer'
    end

    scenario 'add their answer with wrong params to question' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'add their answer with files to question' do
      within '.new-answer' do
        fill_in 'Body', with: 'Custom answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  describe 'Unauthenticated user' do
    background do
      visit question_path(question)
    end
    scenario 'tries to add his answer' do
      expect(page).to_not have_button 'Answer'
    end
  end

end
