require 'rails_helper'
require 'capybara/email/rspec'

feature 'user can be authorized with facebook' do
  background do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(provider: 'facebook',
                                                                           uid: '12345',
                                                                           info: { email: 'facebook@test.com' })
  end

  context 'user does not exist but has facebook account' do
    scenario 'tries to sign up with facebook' do
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'You have to confirm your email address before continuing.'

      open_email('facebook@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  context 'user has authorization with facebook' do
    given(:user) { create(:user) }

    background do
      user.authorizations.create!(provider: 'facebook', uid: '12345')
    end

    scenario 'tries to sign in with with facebook' do
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end

end
