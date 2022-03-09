require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Allows auto-generated examples in swagger docs
RSpec.configure do |config|
  config.swagger_dry_run = false
end

module DiwiApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.active_job.queue_adapter = :sidekiq

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.time_zone = 'Eastern Time (US & Canada)'

    # scaffolds models the TRIM way
    config.generators do |g|
      # views + styles
      g.template_engine     false
      g.stylesheets         false
      g.serializer          true

      # testing (default framework is rspec)
      g.helper_specs        false
      g.controller_specs    false
      g.view_specs          false
      g.routing_specs       false
      g.request_specs       true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
  end
end
