class Photo < ApplicationRecord
  belongs_to :look

  validates :image, :look, presence: true

  mount_uploader :image, ImageUploader
end
