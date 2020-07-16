class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many_attached :files

  validates :body, presence: true

  def best!
    Answer.transaction do
      question.answers.find_by(is_best: true)&.update!(is_best: false)
      update!(is_best: true)
    end unless is_best?
  end
end
