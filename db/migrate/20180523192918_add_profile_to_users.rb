class AddProfileToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :profile, polymorphic: true
  end
end
