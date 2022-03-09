class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  include CarrierWave::Video
  include CarrierWave::Video::Thumbnailer

  # Type of storage to use
  if Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # version :video, :if => :video? do
  #   process :encode
  #   process encode_video: [:mp4, callbacks: { after_transcode: :set_success } ]
  # end

  # # Create different versions of your uploaded files:

  
  version :thumb, :if => :image? do
    process resize_to_fit: [400, 400]
  end

  version :thumb, :if => :video? do
    process thumbnail: [{format: 'png', quality: 8, size: 360, logger: Rails.logger}]
    def full_filename for_file
      png_name for_file, version_name
    end
  end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end

  # def encode
  #   video = FFMPEG::Movie.new(@file.path)
  #   video_transcode = video.transcode(@file.path)
  # end
  
  def extension_whitelist
    %w(mp4 jpg jpeg gif png qt mov)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def fog_authenticated_url_expiration
    7.days
  end


  protected
  def image?(new_file)
    new_file.content_type.include? 'image'
  end
  def video?(new_file)
    new_file.content_type.include? 'video'
  end
end
