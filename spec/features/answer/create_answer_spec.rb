require 'rails_helper'

feature 'add an answer to question', %q{
  In order to answer the question
  As user
  I'd like to be able to leave my answer
} do

  given(:question) { create(:question) }

  before { visit question_path(question) }

  scenario 'User add their answer to question' do
    fill_in 'Body', with: 'Custom answer'
    click_on 'Answer'
    expect(page).to have_content 'Custom answer'
  end

  scenario 'User add their answer with wrong params to question' do
    click_on 'Answer'
    expect(page).to have_content "Body can't be blank"
  end
end
