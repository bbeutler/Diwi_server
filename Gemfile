source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby '2.5.1'

gem 'apnotic'
gem 'bcrypt'
gem 'blueprinter', '~> 0.16.0'
gem 'cancancan'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'carrierwave-ffmpeg'
gem 'carrierwave-video'
gem 'carrierwave-video-thumbnailer'
gem 'factory_bot_rails'
gem 'faker'
gem 'figaro'
gem 'fog-aws'
gem 'jwt'
gem 'knock'
gem 'mandrill-api'
gem 'mime-types'
gem 'mini_magick'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors'
gem 'rails', '~> 5.2.0'
gem 'redis', '~> 4.0'
gem 'rollbar'
gem 'rmagick'
gem 'rspec-rails'
gem 'rswag'
gem 'rswag-specs'
gem 'sass'
gem 'sass-rails'
gem 'sidekiq'
gem 'sprockets', '~> 3.7.2'
# Specific version to support Elastic Search 6
# Because Chewy does not support Elastic Search 7
gem 'chewy', '5.0.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-clipboard'
  gem 'pry-doc'
  gem 'pry-docmore'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  # Create an erd pdf for reference
  gem 'rails-erd'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'json_matchers'
  gem 'rspec'
  gem 'rspec-json_expectations'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
