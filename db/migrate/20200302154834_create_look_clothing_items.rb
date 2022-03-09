class CreateLookClothingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :look_clothing_items do |t|
      t.references :look, foreign_key: true
      t.references :clothing_item, foreign_key: true
      t.timestamps
    end
  end
end
