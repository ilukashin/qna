require 'rails_helper'

feature 'Show list of questions', %q{
  In order to find already existing question
  As an user
  I'd like to see list of all questions
} do

  describe 'If questions exists' do
    given!(:questions) { create_list(:question, 3) }

    scenario 'User got list of all questions' do
      visit questions_path
      expect(page).to have_content questions[0].title
      expect(page).to have_content questions[1].title
      expect(page).to have_content questions[2].title
    end
  end

  scenario 'Got message if there is no questions created' do
    visit questions_path
    expect(page).to have_content 'No questions found.'
  end
end


