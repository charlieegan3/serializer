require_relative '../../config/environment'

task :clean_inactive_sessions do
  Session.where('updated_at < ?', 2.weeks.ago).delete_all
end
