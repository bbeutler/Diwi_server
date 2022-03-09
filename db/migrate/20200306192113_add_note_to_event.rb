class AddNoteToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :note, :string
  end
end
