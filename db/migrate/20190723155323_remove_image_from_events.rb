class RemoveImageFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :image, :string
  end
end
