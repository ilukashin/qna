require 'rails_helper'

feature 'Unregistered user can sign up', %q{
  In order to ask questions and answers
  As unregistered user
  I'd like to be able to sign up
} do

  scenario 'Registration with valid params' do
    visit new_user_registration_path
    fill_in 'Email', with: "user.email@test.com"
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
  end

  describe 'Registration with invalid' do
    scenario 'email' do
      visit new_user_registration_path
      fill_in 'Email', with: "user.email"
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_on 'Sign up'

      expect(page).to have_content "Email is invalid"
    end

    scenario 'password' do
      visit new_user_registration_path
      fill_in 'Email', with: "user.email@test.com"
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '123456789'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match"
    end

  end
end
