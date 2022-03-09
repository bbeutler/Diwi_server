class AddPropertiesToClothingItems < ActiveRecord::Migration[5.2]
  def change
    add_column :clothing_items, :note, :string
    add_column :clothing_items, :dates_worn, :date, array: true, default: []
  end
end
