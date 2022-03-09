# This migration is reversible
class RemoveUnneededV1Tables < ActiveRecord::Migration[5.2]
  def change
    # JOIN TABLES
    drop_table :clothing_item_tags do |t|
      t.references :tag, foreign_key: true
      t.references :clothing_item, foreign_key: true
      t.timestamps
    end

    drop_table :event_clothing_items do |t|
      t.references :event, foreign_key: true
      t.references :clothing_item, foreign_key: true
    end

    drop_table :event_tags do |t|
      t.references :event, foreign_key: true
      t.references :tag, foreign_key: true
      t.timestamps
    end

    drop_table :look_clothing_items do |t|
      t.references :look, foreign_key: true
      t.references :clothing_item, foreign_key: true
      t.timestamps
    end

    drop_table :look_events do |t|
      t.references :look, foreign_key: true
      t.references :event, foreign_key: true
      t.timestamps
    end

    # INDEXES

    remove_index :clothing_items, :type_of

    # TABLES (most recently created first)

    drop_table :members do |t|
      t.references :tag, foreign_key: true
      t.references :group, foreign_key: true
      t.timestamps
    end

    drop_table :messages do |t|
      t.belongs_to :conversation, foreign_key: true
      t.belongs_to :consumer, foreign_key: true
      t.string :body, null: false
      t.boolean :is_read, default: false
      t.timestamps
    end

    drop_table :conversations do |t|
      t.belongs_to :group, foreign_key: true
      t.timestamps
    end

    drop_table :groups do |t|
      t.references :tags, foreign_key: true
      t.bigint :owner_id
      t.string :name, null: false
      t.timestamps
    end

    drop_table :events do |t|
      t.string :name
      t.datetime :date, null: false
      t.references :consumer, foreign_key: true
      t.references :location, foreign_key: true
      t.string :note
      t.timestamps
    end

    drop_table :clothing_items do |t|
      t.string :image
      t.string :name
      t.integer :type_of
      t.references :consumer, foreign_key: true
      t.string :note
      t.date :dates_worn, array: true, default: []
      t.timestamps
    end
  end
end
