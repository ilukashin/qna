require 'rails_helper'

RSpec.describe NewAnswerNotifyJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }
  let(:service) { double('NewAnswerNotifyService') }

  before do
    allow(NewAnswerNotifyService).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNotifyService#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    NewAnswerNotifyJob.perform_now(answer)
  end
end
