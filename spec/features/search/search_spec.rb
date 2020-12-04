require 'rails_helper'

feature 'Search text on website', %q{
  User can get search records
  by text
}, elasticsearch: true do
  given(:user) { create(:user) }

  background do
    @question = create(:question, title: 'some title', body: 'some text', author: user)
    @answer = create(:answer, question: @question, body: 'example answer')
    @comment = create(:comment, commentable: @question, body: 'example comment', author: user)
    [Question, Answer, Comment].each { |model| model.__elasticsearch__.refresh_index! }
  end

  describe 'Authenticated user can' do
    background do
      sign_in(user)
      visit root_path
    end

    scenario 'search for questions' do
      within '.search' do
        fill_in 'Search', with: @question.title
        click_on 'Go'
      end

      expect(page).to have_link(@question.title)
      expect(page).to have_text(@question.body)
    end

    scenario 'search for answer' do
      within '.search' do
        fill_in 'Search', with: @answer.body
        click_on 'Go'
      end

      expect(page).to have_link(@answer.question.title)
      expect(page).to have_text(@answer.body)
    end

    scenario 'search for comments' do
      within '.search' do
        fill_in 'Search', with: @comment.body
        click_on 'Go'
      end

      expect(page).to have_link(@comment.commentable.title)
      expect(page).to have_text(@comment.body)
    end
  end

  describe 'Unauthenticated user can' do
    background do
      visit root_path
    end

    scenario 'search for questions' do
      within '.search' do
        fill_in 'Search', with: @question.title
        click_on 'Go'
      end

      expect(page).to have_link(@question.title)
      expect(page).to have_text(@question.body)
    end

    scenario 'search for answer' do
      within '.search' do
        fill_in 'Search', with: @answer.body
        click_on 'Go'
      end

      expect(page).to have_link(@answer.question.title)
      expect(page).to have_text(@answer.body)
    end

    scenario 'search for comments' do
      within '.search' do
        fill_in 'Search', with: @comment.body
        click_on 'Go'
      end

      expect(page).to have_link(@comment.commentable.title)
      expect(page).to have_text(@comment.body)
    end
  end
end
