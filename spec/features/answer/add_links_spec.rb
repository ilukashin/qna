require 'rails_helper'

feature 'User can add links to answers', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:test_link ) { 'https://github.com' }
  given(:test_link2 ) { 'https://google.com' }

  describe 'User', js: true do
    background do
      sign_in user
      visit question_path(question)

      within '.new-answer' do
        fill_in 'Body', with: 'Custom answer'
      end
    end

    scenario 'User adds link when give an answer' do


      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: test_link
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My link', href: test_link
      end
    end

    scenario 'can add additional links when asks question' do
      click_on 'Add link'

      within all('.new-answer .nested-fields')[0] do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: test_link
      end

      within all('.new-answer .nested-fields')[1] do
        fill_in 'Link name', with: 'My link2'
        fill_in 'Url', with: test_link2
      end
      click_on 'Answer'

      expect(page).to have_link 'My link', href: test_link
      expect(page).to have_link 'My link2', href: test_link2
    end
  end


end
