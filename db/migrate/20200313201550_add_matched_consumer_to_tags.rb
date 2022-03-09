class AddMatchedConsumerToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :matched_to_consumer_id, :bigint
  end
end
