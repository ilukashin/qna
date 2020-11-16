require 'rails_helper'

feature 'Subsciptions', %q{
  User can manage his subsciptions
  on question page
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in user
    end

    describe 'already subscribed to question' do
      given!(:subscription) { create(:subscription, question: question, user: user) }

      background { visit question_path(question) }

      scenario 'should see #unsubscribe link' do
        within '.subscription' do
          expect(page).to have_link 'Unsubscribe'
        end
      end

      scenario 'should cancel subscription on #unsubscribe click' do
        click_on 'Unsubscribe'

        expect(user.subscriptions.reload.count).to eq 0
      end
    end

    describe 'does not subscribed to question' do

      background { visit question_path(question) }

      scenario 'should see subscribe link' do
        within '.subscription' do
          expect(page).to have_link 'Subscribe'
        end
      end

      scenario 'should create subscription on #unsubscribe click' do
        click_on 'Subscribe'

        expect(user.subscriptions.reload.count).to eq 1
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'dont see subscribe link' do
      within '.subscription' do
        expect(page).to_not have_link 'Subscribe'
      end
    end

    scenario 'dont see unsubscribe link' do
      within '.subscription' do
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end
end
