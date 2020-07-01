class AnswersController < ApplicationController
  before_action :set_question, only: %i[new create]

  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer
    else
      render :new
    end

  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
