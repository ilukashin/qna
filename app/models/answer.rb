class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  def best!
    question.answers.find_by(is_best: true)&.cancel_best
    self.is_best = true
    save
  end

  def best?
    self.is_best
  end

  def cancel_best
    self.is_best = false
    save
  end
end
