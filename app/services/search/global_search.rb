# TODO step through search
# make a test
module Search
  class GlobalSearch
    attr_accessor :search_term,
                  :consumer_id

    def initialize(consumer_id, search_term)
      @consumer_id = consumer_id
      @search_term = search_term.kind_of?(Array) ? search_term.join(' ') : search_term
    end

    def search
      {
        tags: tag_search,
        looks: look_search,
        dates: date_search
      }
    end


    private

    # Searches a consumers tags, then searches for looks with that tag in the title
    def tag_search
      @tag_results = Search::TagSearch.new(search_term, consumer_id).search
      return [] if @tag_results.to_a.map(&:title).length == 0
      tag_names = @tag_results.to_a.map(&:title)
      Search::LookSearch.new(@consumer_id, nil, tag_names, nil ).search
    end

    # Searches for looks in notes, title and location
    def look_search
      Search::LookSearch.new(
        consumer_id,
        search_term,
        nil,
        nil
      ).search
    end

    # Returns month that match the given string from looks
    def date_search
      return [] unless @search_term && keyword_matches_month_name?

      all_looks = Look.where(consumer_id: @consumer_id)
      look_results = all_looks.select do |look|
        look.dates_worn.flatten.map { |d| d.strftime('%B').downcase}.include?(@search_term.downcase)
      end
      look_results
    end

    def keyword_matches_month_name?
      regex = Regexp.new(@search_term, Regexp::IGNORECASE)
      @month_matches = Date::MONTHNAMES.compact.grep(regex)
      @month_matches.count.positive?
    end
  end
end
