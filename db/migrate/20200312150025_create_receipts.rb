class CreateReceipts < ActiveRecord::Migration[5.2]
  def change
    create_table :receipts do |t|
      t.belongs_to :subscription, foreign_key: true
      t.string :transaction_identifier
      t.timestamps
    end
  end
end
