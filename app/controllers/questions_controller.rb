class QuestionsController < ApplicationController
  before_action :find_question, only: %i[show destroy update]
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: %i[create]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    @subscription = @question.subscriptions.where(user: current_user).first
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user&.author_of?(@question)
      @question.update(question_params)
      render :update
    else
      render head: :forbidden, status: 403
    end
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Successfully deleted question.'
    else
      redirect_to @question, notice: 'Only author can delete this question.'
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :picture])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/question',
            locals: { question: @question }
        )
    )
  end
end
