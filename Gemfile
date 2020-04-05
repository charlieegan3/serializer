source "https://rubygems.org"

ruby "2.4.1"

gem 'rake', '12.3.1'

gem "feedjira"
gem "gruff"
gem "httpclient"
gem "jaccard"
gem "nokogiri", "~> 1.8.1"
gem "open_uri_redirections"
gem "pg"
gem "prometheus-client"
gem "rails"
gem "random_username"
gem "rufus-scheduler"
gem "sass-rails"
gem "slim"
gem "therubyracer"
gem "uglifier"
gem "dotenv-rails"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "pry"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "guard"
  gem "guard-rspec", require: false
  gem "rails-controller-testing"
  gem "rspec"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "vcr"
  gem "webmock"
end
