class AddUsernameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :consumers, :username, :string, null: false

    add_index :consumers, :username, unique: true
  end
end
