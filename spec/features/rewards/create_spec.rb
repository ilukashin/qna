require 'rails_helper'

feature 'Create rewards', %q{
  In order to reward best answer
  As an author of question
  I can create reward when asks a question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'can add reward when asks a question' do
      fill_in 'Reward name', with: 'My reward'
      attach_file 'Picture', "#{Rails.root}/spec/rails_helper.rb"

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test question body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test question body'
    end

  end
end
