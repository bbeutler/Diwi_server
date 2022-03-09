class CreateEventClothingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :event_clothing_items do |t|
      t.references :event, foreign_key: true
      t.references :clothing_item, foreign_key: true
    end
  end
end
