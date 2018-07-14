require 'simplecov'
SimpleCov.start

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
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

module Shoulda
  module Matchers
    RailsShim.class_eval do
      def self.serialized_attributes_for(model)
        if defined?(::ActiveRecord::Type::Serialized)
          # Rails 5+
          model.columns.select do |column|
            model.type_for_attribute(column.name).is_a?(::ActiveRecord::Type::Serialized)
          end.inject({}) do |hash, column|
            hash[column.name.to_s] = model.type_for_attribute(column.name).coder
            hash
          end
        else
          model.serialized_attributes
        end
      end
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end
