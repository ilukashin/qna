class SearchService
  MODELS_TO_SEARCH = [Question, Answer, Comment].freeze

  def search(query)
    data = run_elastic(query).records.to_a
    results_mapping(data)
  end

  private

  def run_elastic(query)
    Elasticsearch::Model.search(query, MODELS_TO_SEARCH)
  end

  def results_mapping(data)
    data.map do |record|
      {
        title: get_record_title(record),
        details: record.body,
        controller: record.model_name.plural,
        id: record.id
      }
    end
  end

  def get_record_title(record)
    case record.class.to_s.downcase.to_sym
    when :question then record.title
    when :answer then record.question.title
    when :comment then get_record_title(record.commentable)
    else 'Unknown type of record'
    end
  end

end
