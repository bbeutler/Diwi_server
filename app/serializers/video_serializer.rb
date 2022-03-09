class VideoSerializer < ApplicationSerializer
  identifier :id

  field :video do |video|
    video.video.url
  end
end
