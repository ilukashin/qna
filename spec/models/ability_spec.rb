require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :oauth_email_confirmation, User }
    it { should be_able_to :authenticate, :oauth_provider }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:question2) { create(:question, author: other) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:answer2) { create(:answer, question: question, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :read, Reward }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, question2 }
    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, question2 }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, answer2 }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, answer2 }

    it { should be_able_to :best, create(:answer, question: question, author: user2) }
    it { should_not be_able_to :best, create(:answer, question: question2, author: user2) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: question2) }

    it { should_not be_able_to :up, question, author: user }
    it { should be_able_to :up, question2, author: user }
    it { should_not be_able_to :down, question, author: user }
    it { should be_able_to :down, question2, author: user }

    context 'attachments' do
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
      it { should be_able_to :destroy, question.files.first }
      it { should be_able_to :destroy, answer.files.first }
    end
  end
end
