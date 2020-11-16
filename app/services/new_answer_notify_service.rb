class NewAnswerNotifyService

  def send_notification(answer)
    subscriptions = Subscription.where(question: answer.question)

    subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerNotifyMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
