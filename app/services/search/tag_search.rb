module Search
  class TagSearch
    attr_accessor :search_term, :consumer_id, :tags

    def initialize(search_term, consumer_id)
      @search_term = search_term
      @consumer_id = consumer_id
    end

    def search
      @tags = @search_term ? search_by_term.to_a : []
    end

    private

    def index
      TagsIndex
    end

    def search_by_term
      index.filter(
        'term': { 'consumer_id': @consumer_id }
      ).query(
        'multi_match': {
          'query': search_term,
          'type': 'phrase_prefix',
          'fields': fields,
        }
      )
    end

    def fields
      %w[title]
    end
  end
end
