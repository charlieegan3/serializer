require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.start
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'vcr'
require 'webmock/rspec'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!

  config.include Capybara::DSL
  config.include FactoryGirl::Syntax::Methods
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.ignore_hosts 'codeclimate.com'
end
