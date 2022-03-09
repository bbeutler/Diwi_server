class UpdatesLocationAttributes < ActiveRecord::Migration[5.2]
  def up
    rename_column :locations, :lat, :latitude
    rename_column :locations, :lng, :longitude
    rename_column :locations, :zip, :postal_code
    change_column :locations, :latitude, :float, null: true
    change_column :locations, :longitude, :float, null: true
    change_column :locations, :city, :string, null: false
    change_column :locations, :state, :string, null: false
    change_column :locations, :street, :string, null: false
    change_column :locations, :postal_code, :string, null: false
  end

  def down
    change_column :locations, :postal_code, :string, null: true
    change_column :locations, :street, :string, null: true
    change_column :locations, :state, :string, null: true
    change_column :locations, :city, :string, null: true
    change_column :locations, :longitude, :float, null: false
    change_column :locations, :latitude, :float, null: false
    rename_column :locations, :postal_code, :zip
    rename_column :locations, :longitude, :lng
    rename_column :locations, :latitude, :lat
  end
end
