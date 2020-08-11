require 'active_support/concern'

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote!(user)
    unless liked_by?(user)
      vote = self.votes.find_by(user: user)
      if vote
        vote.update!(value: 1)
      else
        self.votes.create!(user: user, value: 1)
      end
    end
  end

  def downvote!(user)
    unless disliked_by?(user)
      vote = self.votes.find_by(user: user)
      if vote
        vote.update!(value: -1)
      else
        self.votes.create!(user: user, value: -1)
      end
    end
  end

  def liked_by?(user)
    self.votes.where(user: user, value: 1).any?
  end

  def disliked_by?(user)
    self.votes.where(user: user, value: -1).any?
  end

  def rating
    self.votes.pluck(:value).sum
  end

end
