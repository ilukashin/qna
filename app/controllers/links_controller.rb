class LinksController < ApplicationController

  def destroy
    @link = Link.find(params[:id])

    if current_user&.author_of?(@link.linkable)
      @link.destroy
      render :destroy
    else
      render head: :forbidden, status: 403
    end
  end
end
