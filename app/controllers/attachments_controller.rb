class AttachmentsController < ApplicationController

  def delete_attached_file
    file = ActiveStorage::Attachment.find(params[:id])
    @question = file.record
    if current_user&.author_of?(@question)
      file.purge
      @file_id = file.id
      render :delete_attached_file
    else
      render head: :forbidden, status: 403
    end
  end

end
