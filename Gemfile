source 'https://rubygems.org'

ruby "2.4.1"

gem 'rails'

gem 'therubyracer'

gem 'activerecord-cockroachdb-adapter'

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

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rspec'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'factory_bot_rails'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end
