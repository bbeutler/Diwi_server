class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.references :consumer, foreign_key: true
      t.string :device_token, limit: 255, null: false
      t.boolean :enabled, default: true, null: false
      t.integer :platform, null: false
      t.timestamps
    end
  end
end
