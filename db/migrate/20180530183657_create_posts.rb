class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :title
      t.text :body
      t.integer :category

      t.timestamps
    end
  end
end
