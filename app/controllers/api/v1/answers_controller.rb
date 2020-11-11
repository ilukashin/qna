class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource
  before_action :find_answer, only: %i[show destroy update]

  def index
    @answers = question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.author = current_resource_owner
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer
    @answer.destroy
    render json: { message: 'Successfully deleted question.' }, status: :ok
  end

  def update
    authorize! :update, @answer
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

end
