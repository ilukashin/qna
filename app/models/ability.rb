# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
    can :authenticate, :oauth_provider
    can :oauth_email_confirmation, User
    can :create, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], author_id: user.id
    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :up, [Question, Answer]
    cannot :up, [Question, Answer], author_id: user.id
    can :down, [Question, Answer]
    cannot :down, [Question, Answer], author_id: user.id

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can :read, Reward
  end
end
