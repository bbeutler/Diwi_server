class ChangeLocationDefault < ActiveRecord::Migration[5.2]
  def up
    change_column_null :looks, :location, true
  end

  def down
    change_column_null :looks, :location, false
  end
end
