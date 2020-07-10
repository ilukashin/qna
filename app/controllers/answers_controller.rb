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
    @answer.save
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user&.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Successfully deleted answer.'
    else
      redirect_to question_path(@answer.question), notice: 'Only author can delete this answer.'
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
