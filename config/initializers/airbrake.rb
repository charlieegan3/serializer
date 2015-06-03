Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_KEY']
  config.development_environments = []
end
