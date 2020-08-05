require 'rails_helper'

feature 'Show rewards', %q{
  As an author of best answers
  I'd like to be able to watch my rewards
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:question2) { create(:question, author: user) }
  given!(:reward) { create(:reward, name: 'Winner', question: question, user: user) }
  given!(:reward2) { create(:reward, name: 'Best practice', question: question2, user: user) }



  describe 'Authenticated user' do
    background do
      sign_in user
      visit root_path
    end

    scenario 'can watch his rewards' do
      click_on 'Rewards'

      expect(page).to have_content 'Winner'
      expect(page).to have_content question.title
      expect(page).to have_content 'Best practice'
      expect(page).to have_content question2.title
    end
  end
end
