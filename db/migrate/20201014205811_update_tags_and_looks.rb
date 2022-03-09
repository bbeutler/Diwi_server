class UpdateTagsAndLooks < ActiveRecord::Migration[5.2]
  def up
    remove_column :tags, :note, :string
    remove_column :tags, :dates_with, :date, default: [], array: true
    remove_column :tags, :matched_to_consumer_id, :bigint
    change_column :tags, :title, :string, null: false
    add_column :looks, :location, :string
    remove_index :consumers, :username
    change_column :consumers, :username, :string, null: true
  end

  def down
    change_column :consumers, :username, :string, null: false
    add_index :consumers, :username, unique: true
    remove_column :looks, :location, :string
    change_column :tags, :title, :string, null: true
    add_column :tags, :matched_to_consumer_id, :bigint
    add_column :tags, :dates_with, :date, default: [], array: true
    add_column :tags, :note, :string
  end
end
