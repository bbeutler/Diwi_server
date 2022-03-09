class TagsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      lower_name: {
        tokenizer: 'standard',
        filter: ['lowercase']
      }
    }
  }

  define_type Tag do
    field :title, type: 'text', analyzer: 'lower_name'
    field :created_at, type: 'date'
    field :consumer_id, type: 'integer'
  end
end
