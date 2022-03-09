class CreateClothingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :clothing_items do |t|
      t.string :image
      t.string :name
      t.integer :type_of
      t.references :consumer, foreign_key: true

      t.timestamps
    end

    add_index :clothing_items, :type_of
  end
end
