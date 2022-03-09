class AddImageToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :images, :json
  end
end
