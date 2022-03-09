module Search
  class LookSearch
    attr_accessor :search_term, :consumer_id, :tag_names, :date_filter

    def initialize(
      consumer_id,
      search_term = nil,
      tag_names = nil,
      date_filter = nil # Example: December 2020
    )
      @consumer_id = consumer_id
      @search_term = search_term
      @tag_names = tag_names.kind_of?(Array) ? tag_names.join(' ') : tag_names
      @date_filter = date_filter
    end

    def search
      search_results = if @date_filter
                         filter_by_date_range
                       elsif @tag_names
                         find_by_friend.to_a
                       else
                         keyword_search.to_a
                       end

      search_results
    end

    private

    def index
      LooksIndex
    end

    def fields
      %w[title location note]
    end

    def keyword_search
      index.filter(
        'term': { 'consumer_id': @consumer_id }
      ).query(
        'multi_match': {
          'query': @search_term,
          'type': 'phrase_prefix',
          'fields': fields,
        }
      )
    end

    # Find Looks by name of the friend
    # Returns tag names
    def find_by_friend
      index.filter(
          'term': { 'consumer_id': @consumer_id }
        ).query(
          'multi_match': {
            'query': @tag_names,
            'type': 'phrase_prefix',
            'fields': ['tags'],
          }
        )
    end

    # Greater than or equal to requirement must go last
    # to avoid extra dates from the past
    def filter_by_date_range
      index.filter(
        'term': { 'consumer_id': @consumer_id }
      ).filter(
        'bool': {
          'must': [
            {
              'range': {
                'dates_worn': {
                  'lte': end_date,
                  'format': 'yyyy-MM-dd'
                }
              }
            },
            {
              'range': {
                'dates_worn': {
                  'gte': start_date,
                  'format': 'yyyy-MM-dd'
                }
              }
            }
          ]
        }
      )
    end

    def start_date
      DateTime.parse(@date_filter).strftime('%Y-%m-%d')
    end

    def end_date
      DateTime.parse(@date_filter).end_of_month.strftime('%Y-%m-%d')
    end
  end
end
