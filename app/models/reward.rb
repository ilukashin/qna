class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  has_one_attached :picture

  validates :name, presence: true

  def assign_to!(user)
    update!(user_id: user.id)
  end
end
