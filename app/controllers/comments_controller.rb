class CommentsController < ApplicationController
  before_action :find_commentable
  before_action :authenticate_user!

  after_action :publish_comment, only: %i[create]

  def create
    @comment = Comment.new(comment_params)
    @comment.author = current_user
    @comment.commentable = @commentable
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:question_id]
      @commentable = Question.find_by_id(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find_by_id(params[:answer_id])
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comment_on_question_#{@comment.commentable.id}",
        @comment
    )
  end

end
