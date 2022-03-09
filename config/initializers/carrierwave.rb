if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end
else
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_KEY'],
      aws_secret_access_key: ENV['AWS_SECRET'],
      region: ENV['AWS_REGION']
    }
    config.fog_directory = ENV['AWS_BUCKET'] # required
    config.fog_public = false # optional, defaults to true
    config.storage = :fog
    config.cache_dir = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on heroku
  end
end
