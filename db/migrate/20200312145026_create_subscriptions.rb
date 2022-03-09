class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :consumer, foreign_key: true
      t.integer :method_of_payment, null: false
      t.string  :product_id, null: false
      t.string  :product_name, null: false
      t.boolean :is_active, default: false

      t.timestamps
    end
  end
end
