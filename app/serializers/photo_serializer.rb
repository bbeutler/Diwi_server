class PhotoSerializer < ApplicationSerializer
  identifier :id

  field :image do |photo|
    photo.image.url
  end

  field :thumbnail do |photo|
    if !photo.image.thumb.url
      photo.image.url
    else
      photo.image.thumb.url
    end
  end
end
