class Video < ApplicationRecord
	belongs_to :look

  validates :video, :look, presence: true

  mount_uploader :video, ImageUploader
end
