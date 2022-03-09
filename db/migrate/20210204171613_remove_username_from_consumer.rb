class RemoveUsernameFromConsumer < ActiveRecord::Migration[5.2]
  def change
    remove_column :consumers, :username
  end
end
