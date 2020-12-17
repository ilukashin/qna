class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :new_answer_notification

  settings do
    mappings dynamic: false do
      indexes :body, type: :text
    end
  end

  def best!
    Answer.transaction do
      question.answers.find_by(is_best: true)&.update!(is_best: false)
      update!(is_best: true)
      question.reward&.assign_to!(author)
    end unless is_best?
  end

  def new_answer_notification
    NewAnswerNotifyJob.perform_later(self)
  end
end
