require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 3) }
  let(:questions) { create_list(:question, 3) }


  it 'sends daily digest to all users' do
    questions_list = Question.where(created_at: (Time.current - 1.day)..Time.current).pluck(:title)

    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_list).and_call_original }
    subject.send_digest
  end
end
