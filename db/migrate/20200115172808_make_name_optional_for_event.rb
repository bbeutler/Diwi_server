class MakeNameOptionalForEvent < ActiveRecord::Migration[5.2]
  def change
    change_column_null :events, :name, true
  end
end
