require 'rails_helper'

feature 'User can add links to answers', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:test_link ) { 'https://github.com' }

  scenario 'User adds link when give an answer', js: true do
    sign_in user
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Custom answer'
    end

    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: test_link
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My link', href: test_link
    end
  end

end
