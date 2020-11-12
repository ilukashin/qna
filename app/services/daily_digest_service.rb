class DailyDigestService
  def send_digest
    questions = Question.where(created_at: (Time.current - 1.day)..Time.current).pluck(:title)

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
