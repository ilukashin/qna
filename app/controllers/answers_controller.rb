class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_question, only: %i[new create]
  before_action :find_answer, only: %i[show edit update destroy best]

  def show; end

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
    @answer.update(answer_params) if current_user&.author_of?(@answer)
  end

  def destroy
    if current_user&.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Successfully deleted answer.'
    else
      redirect_to question_path(@answer.question), notice: 'Only author can delete this answer.'
    end
  end

  def best
    @answer.best! if current_user&.author_of?(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
