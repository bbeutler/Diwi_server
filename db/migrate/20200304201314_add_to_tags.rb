class AddToTags < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :dates_with, :date, array: true, default: []
    add_column :tags, :note, :string
  end
end
