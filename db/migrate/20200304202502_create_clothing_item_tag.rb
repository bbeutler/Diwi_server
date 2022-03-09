class CreateClothingItemTag < ActiveRecord::Migration[5.2]
  def change
    create_table :clothing_item_tags do |t|
      t.references :tag, foreign_key: true
      t.references :clothing_items, foreign_key: true
      t.timestamps
    end
  end
end
