class CreateTaggs < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :title
      t.references :consumer, foreign_key: true

      t.timestamps
    end
  end
end
