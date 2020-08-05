require 'rails_helper'

feature 'Assign reward', %q{
  User can get reward
  If he is author of best answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:reward) { create(:reward, question: question) }
  given!(:answer) { create(:answer, question: question, author: user2) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Choose best'
    end

    scenario 'user can get reward' do
      # в бекграунде при выборе лучшего ответа судя по всему не успевает отработать
      # транзакция в Answer#best!  - выяснил опытным путем.
      # поэтому решил подождать пока отрендерится
      # sleep осознанно стараюсь не использовать в тестах
      expect(page).to have_css('.best')
      expect(user2.rewards.count).to eql 1
    end
  end
end
