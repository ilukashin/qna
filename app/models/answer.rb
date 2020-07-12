class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  def best!
    question.best_answer_id = id
    question.save
  end

  def best?
    id == question.best_answer_id
  end

end
