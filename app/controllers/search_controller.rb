class SearchController < ApplicationController

  skip_authorization_check
  skip_authorize_resource

  def search
    if query.present?
      @results = SearchService.new.search(query, query_params[:query_class])
    end

    render :results
  end

  private

  def query_params
    params.require(:search).permit(:query, :query_class)
  end

  def query
    @query ||= query_params[:query]
  end
end
