class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.belongs_to :conversation, foreign_key: true
      t.belongs_to :consumer, foreign_key: true
      t.string :body, null: false
      t.timestamps
    end
  end
end
