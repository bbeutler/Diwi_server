class ChangeColumnInClothingItemTags < ActiveRecord::Migration[5.2]
  def change
    rename_column :clothing_item_tags, :clothing_items_id, :clothing_item_id
  end
end
