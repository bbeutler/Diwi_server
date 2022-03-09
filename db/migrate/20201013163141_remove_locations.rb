class RemoveLocations < ActiveRecord::Migration[5.2]
  def change
    drop_table :locations do |t|
      t.string :city, null: false
      t.string :state, null: false
      t.string :street, null: false
      t.string :postal_code, null: false
      t.string :google_place_id
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
