class NewAnswerNotifyService

  def send_notification(answer)
    question_author = answer.question.author

    NewAnswerNotifyMailer.notify(question_author, answer).deliver_later
  end
end
