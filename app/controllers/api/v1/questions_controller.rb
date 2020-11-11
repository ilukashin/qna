class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  before_action :find_question, only: %i[show destroy update]

  skip_before_action :verify_authenticity_token, only: %i[create destroy]

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    render json: { message: 'Successfully deleted question.' }, status: :ok
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :picture])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
