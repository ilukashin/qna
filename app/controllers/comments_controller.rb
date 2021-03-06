class CommentsController < ApplicationController
  before_action :find_commentable
  before_action :authenticate_user!, only: :create

  after_action :publish_comment, only: %i[create]

  def show
    redirect_to Comment.find(params[:id]).commentable
  end

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
      @question_id = params[:question_id]
    elsif params[:answer_id]
      @commentable = Answer.find_by_id(params[:answer_id])
      @question_id = @commentable.question.id
    end
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
        "comment_on_question_#{@question_id}",
        @comment
    )
  end

end
