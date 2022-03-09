# This migration is reversible
class RemovesUnneededTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :images, :json

    drop_table :taggings do |t|
      t.belongs_to :post, foreign_key: true
      t.belongs_to :tag, foreign_key: true

      t.timestamps
    end

    remove_index :tags, column: :name, unique: true

    drop_table :tags do |t|
      t.string :name, null: false

      t.timestamps
    end

    drop_table :posts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :title
      t.text :body
      t.integer :category

      t.timestamps
    end
  end
end
