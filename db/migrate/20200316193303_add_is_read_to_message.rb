class AddIsReadToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :is_read, :boolean, default: false
  end
end
