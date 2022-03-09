class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :city
      t.string :state
      t.string :street
      t.string :zip
      t.string :google_place_id
      t.float :lat, null: false
      t.float :lng, null: false

      t.timestamps
    end

    add_reference :events, :location, foreign_key: true
  end
end
