Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_KEY']
  config.development_environments = []
  config.ignore << 'Errno::ENETUNREACH'
  config.ignore << 'SocketError'
  config.ignore << 'Timeout::Error'
  config.ignore << 'OpenURI::HTTPError'
  config.ignore << 'PG::UniqueViolation'
  config.ignore << 'ActiveRecord::RecordInvalid'
end
