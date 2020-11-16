# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notify_mailer
class NewAnswerNotifyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notify_mailer/notify
  def notify
    NewAnswerNotifyMailer.notify
  end

end
