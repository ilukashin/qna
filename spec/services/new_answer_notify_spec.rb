require 'rails_helper'

RSpec.describe NewAnswerNotifyService do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends report about new answer' do
    expect(NewAnswerNotifyMailer).to receive(:notify).with(subscription.user, answer).and_call_original
    subject.send_notification(answer)
  end
end
