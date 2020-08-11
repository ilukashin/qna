require 'rails_helper'

feature 'User can down vote for record', %q{
  In order to improve information about useful record
  As an user
  I'd like to be able to decrease rating of reecord
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }


  describe 'Authenticated user', js: true do
    describe 'as not author' do
      background do
        sign_in(user2)
        visit question_path(question)
      end

      scenario 'can down vote' do
        click_on 'Down'
        expect(page).to have_content('Rating:-1')
      end

      scenario 'can down vote only once' do
        click_on 'Down'
        expect(page).to have_content('Rating:-1')

        click_on 'Down'
        expect(page).to have_content('Rating:-1')
      end
    end

    describe 'as author' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'can not vote' do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end
  end


  describe 'Unauthenticated user can not up vote' do
    background do
      visit question_path(question)
    end
    scenario 'user do not have buttons to change rating' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end
end
