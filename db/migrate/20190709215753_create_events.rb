class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :image
      t.string :name, null: false
      t.datetime :date, null: false
      t.references :consumer, foreign_key: true

      t.timestamps
    end
  end
end
