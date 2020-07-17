require 'rails_helper'

feature 'User can delete attachments', %q{
  In order to correct mistakes
  As an author of answer or question
  I'd like to be able to delete attachments
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do

    describe 'an author' do
      background do
        sign_in user
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        visit question_path(question)
      end

      scenario 'can delete file in question' do
        within ('.question .attached-file') do
          click_on 'Delete file'
        end
        expect(page).to_not have_link 'rails_helper.rb'
      end

      scenario 'can delete file in answer' do
        within '.answers' do
          click_on 'Delete file'
        end
        expect(page).to_not have_link 'spec_helper.rb'
      end
    end

    describe 'not author of' do
      background do
        sign_in user2
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
        visit question_path(question)
      end

      scenario 'cant delete attachment from question' do
        within ('.question .attached-file') do
          expect(page).to_not have_link 'Delete file'
        end
      end

      scenario 'cant delete attachment from answer' do
        within '.answers' do
          expect(page).to_not have_link 'Delete file'
        end
      end
    end

  end

  describe 'Unauthenticated user' do
    background do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      visit question_path(question)
    end

    scenario 'cant delete attachment from question' do
      within ('.question .attached-file') do
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'cant delete attachment from answer' do
      within '.answers' do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

end
