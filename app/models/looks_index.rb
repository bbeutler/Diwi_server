class LooksIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      lower_name: {
        tokenizer: 'standard',
        filter: ['lowercase']
      }
    }
  }

  define_type Look.includes(:tags) do
    field :id, type: 'integer'
    field :title, type: 'text', analyzer: 'lower_name'
    field :note, type: 'text', analyzer: 'lower_name'
    field :location, type: 'text', analyzer: 'lower_name'
    field :dates_worn, type: 'date'
    field :tags,
          type: 'text',
          value: ->(look) { look.tags.map(&:title) },
          analyzer: 'lower_name'
    field :created_at, type: 'date'
    field :consumer_id, type: 'integer'
  end
end
