class AnswersChannel < ApplicationCable::Channel

  def follow(params)
    stream_from "answer_on_question_#{params['id']}"
  end
end
