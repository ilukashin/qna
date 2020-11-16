class SubscriptionsController < ApplicationController

  def create
    question = Question.find(params[:question_id])
    unless Subscription.exists?(question: question, user: current_user)
      @subscription = question.subscriptions.create(user: current_user)
      render json: @subscription.id
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    render json: { message: 'Unsubscribed', status: :ok }
  end

end
