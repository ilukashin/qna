require 'rails_helper'

feature 'User can edit answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do

    describe 'an author' do
      background do
        sign_in user
        visit question_path(question)

        click_on 'Edit answer'
      end

      scenario 'can edit his answer' do
        within '.answers' do
          fill_in 'Body', with: 'edited answer'
          click_on 'Update Answer'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'tries edit his answer with errors' do
        within '.answers' do
          fill_in 'Body', with: ''
          click_on 'Update Answer'

          expect(page).to have_content answer.body
          expect(page).to have_content "Body can't be blank"
          expect(page).to have_selector 'textarea'
        end
      end

      scenario 'can attach files' do
        within '.answers' do
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Update Answer'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'can add link' do
        within '.answers' do
          click_on 'Add link'
          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: 'https://github.com'
        end
        click_on 'Update Answer'

        expect(page).to have_link 'My link'
      end
    end

    describe 'not an author' do
      background do
        sign_in user2
        visit question_path(question)
      end

      scenario 'tries to edit others users answer' do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end
end
