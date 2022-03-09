class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.references :tag, foreign_key: true
      t.references :group, foreign_key: true
      t.timestamps
    end
  end
end
