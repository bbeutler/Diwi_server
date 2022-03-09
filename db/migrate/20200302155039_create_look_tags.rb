class CreateLookTags < ActiveRecord::Migration[5.2]
  def change
    create_table :look_tags do |t|
      t.references :tag, foreign_key: true
      t.references :look, foreign_key: true
      t.timestamps
    end
  end
end
