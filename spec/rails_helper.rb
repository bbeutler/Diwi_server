# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'sidekiq/testing'
require 'rspec/json_expectations'
require 'json_matchers/rspec'
require 'webmock/rspec'

ActiveRecord::Migration.maintain_test_schema!
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
WebMock.disable_net_connect!(allow_localhost: true, allow: 'elasticsearch:9200')

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.after(:each) do
    Sidekiq::Worker.clear_all
  end

  config.before :each, type: :request do |example|
    submit_request(example.metadata)
  end

  config.after :each, type: :request do |example|
    # Swagger only allows one response block per status code, skip extra tests if needed
    unless example.metadata[:skip_swagger] || response.body.blank?
      # Sets response example
      example.metadata[:response][:examples] =
        { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
    end

    # Sets request example
    if example.metadata[:request_example] && !example.metadata[:skip_swagger]
      request_example_name = example.metadata[:request_example]
      param = example.metadata[:operation][:parameters].detect { |p| p[:name] == request_example_name }
      param[:schema][:example] =
        send(request_example_name)[request_example_name] || send(request_example_name)
    end
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end
