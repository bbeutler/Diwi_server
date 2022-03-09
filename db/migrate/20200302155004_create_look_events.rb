class CreateLookEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :look_events do |t|
      t.references :look, foreign_key: true
      t.references :event, foreign_key: true
      t.timestamps
    end
  end
end
