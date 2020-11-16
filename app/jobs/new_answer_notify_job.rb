class NewAnswerNotifyJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotifyService.new.send_notification(answer)
  end
end
