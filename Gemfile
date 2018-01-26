source 'https://rubygems.org'

ruby "2.3.1"

gem 'rails', '~> 4.2.5'

gem 'pg'

# collection
gem 'rufus-scheduler'
gem 'nokogiri', '~> 1.8.1'
gem 'feedjira'
gem 'httpclient'
gem 'open_uri_redirections'
gem 'jaccard'

# external
gem 'cloudinary'
gem 'airbrake'
gem 'gruff'

# views
gem 'sass-rails'
gem 'uglifier'
gem 'slim'

# sessions
gem 'random_username'
gem 'ruby-trello'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry'
end

group :development do
  gem 'byebug'
  gem 'web-console', '~> 2.1'
  gem 'better_errors'
  gem 'rails_best_practices'
  gem 'seed_dumper'
end

group :test do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers', '2.8.0'
  gem 'factory_girl_rails'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
end
