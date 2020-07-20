require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:test_link ) { 'https://github.com' }
  given(:test_link2 ) { 'https://google.com' }

  describe 'User' do
    background do
      sign_in user
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'can add one link when asks question' do
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: test_link

      click_on 'Ask'

      expect(page).to have_link 'My link', href: test_link
    end

    scenario 'can add additional links when asks question', js: true do
      click_on 'Add link'

      within all('.links .nested-fields')[0] do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: test_link
      end

      within all('.links .nested-fields')[1] do
        fill_in 'Link name', with: 'My link2'
        fill_in 'Url', with: test_link2
      end
      click_on 'Ask'

      expect(page).to have_link 'My link', href: test_link
      expect(page).to have_link 'My link2', href: test_link2
    end
  end
end
