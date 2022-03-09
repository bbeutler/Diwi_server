class CreateLookTable < ActiveRecord::Migration[5.2]
  def change
    create_table :looks do |t|
      t.string :title
      t.string :note
      t.date :dates_worn, array: true, default: []
      t.references :consumer, foreign_key: true

      t.timestamps
    end
  end
end
