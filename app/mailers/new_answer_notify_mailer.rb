class NewAnswerNotifyMailer < ApplicationMailer

  def notify(user, answer)
    @question = answer.question.title
    @content = answer.body

    mail to: user.mail
  end
end
