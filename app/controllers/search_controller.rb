class SearchController < ApplicationController

  skip_authorization_check
  skip_authorize_resource

  def search
    if query.present?
      @results = SearchService.new.search(query)
    end

    render :results
  end

  private

  def query
    @query ||= params[:search][:query]
  end
end
