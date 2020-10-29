class AttachmentsController < ApplicationController

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    file = ActiveStorage::Attachment.find(params[:id])
    @question = file.record
    if current_user&.author_of?(@question)
      file.purge
      @file_id = file.id
      render :destroy
    else
      render head: :forbidden, status: 403
    end
  end

end
