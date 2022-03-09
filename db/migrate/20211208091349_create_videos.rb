class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.integer :look_id
      t.string :video

      t.timestamps
    end
  end
end
