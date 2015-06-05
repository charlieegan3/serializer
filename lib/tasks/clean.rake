require_relative '../../config/environment'

task :clean_inactive_sessions do
  Session.where('created_at < ?', 12.hours.ago)
    .where(completed_to: nil, sources: nil)
    .delete_all
end
