class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]
  before_action :find_answer, only: %i[show edit update destroy best]

  after_action :publish_answer, only: %i[create]
  
  include Voted

  def show
    redirect_to @answer.question
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def edit; end

  def update
    if current_user&.author_of?(@answer)
      @answer.update(answer_params)
      render :update
    else
      render head: :forbidden, status: 403
    end
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
      render :destroy
    else
      render head: :forbidden, status: 403
    end
  end

  def best
    if current_user&.author_of?(@answer.question)
      @answer.best!
      render :best
    else
      render head: :forbidden, status: 403
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answer_on_question_#{@answer.question.id}",
        @answer
    )
  end
end
