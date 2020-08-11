require 'active_support/concern'

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:up, :down]
  end

  def up
    unless current_user.author_of?(@votable)
      @votable.upvote!(current_user)
    end

    respond_to do |format|
      format.json { render json: @votable.rating }
    end
  end

  def down
    unless current_user.author_of?(@votable)
      @votable.downvote!(current_user)
    end

    respond_to do |format|
      format.json { render json: @votable.rating }
    end
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

end
