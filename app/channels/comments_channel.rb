class CommentsChannel < ApplicationCable::Channel

  def follow(params)
    stream_from "comment_on_question_#{params['id']}"
  end
end
