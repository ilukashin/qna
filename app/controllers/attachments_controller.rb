class AttachmentsController < ApplicationController
  prepend_before_action :find_attachment, only: :destroy

  authorize_resource class: ActiveStorage::Attachment

  def destroy
    @question = @attachment.record
    if current_user&.author_of?(@question)
      @attachment.purge
      @file_id = @attachment.id
      render :destroy
    else
      render head: :forbidden, status: 403
    end
  end

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

end
