require 'rails_helper'

feature 'User can leave comments', :js do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can leave comment to question' do
      within '.question .new-comment' do
        fill_in 'Body', with: 'comment on question'
        click_on 'Comment'
      end

      expect(page).to have_content('comment on question')
    end

    scenario 'can leave comment to answer' do
      within '.answers .new-comment' do
        fill_in 'Body', with: 'comment on answer'
        click_on 'Comment'
      end

      expect(page).to have_content('comment on answer')
    end
  end

  describe 'multiple sessions' do
    scenario "question's comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question .new-comment' do
          fill_in 'Body', with: 'comment on question'
          click_on 'Comment'
        end
  
        expect(page).to have_content('comment on question')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment on question'
      end
    end


    scenario "answer's comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers .new-comment' do
          fill_in 'Body', with: 'comment on answer'
          click_on 'Comment'
        end
  
        expect(page).to have_content('comment on answer')
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'comment on answer'
      end
    end
  end

  
end
