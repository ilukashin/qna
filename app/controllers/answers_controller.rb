class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]

  def show
    @answer = Answer.find(params[:id])
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @answer.question
    else
      redirect_to @answer.question, notice: @answer.errors.full_messages.join(' ')
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.author == current_user
      @answer.destroy
      redirect_to root_path, notice: 'Successfully deleted answer.'
    else
      redirect_to @answer, notice: 'Only author can delete this answer.'
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
