require_relative '../../config/environment'

task :clean_old_data do
  Session.where('updated_at < ?', 30.days.ago).delete_all
  Session.where(read_count: nil).delete_all
  Item.where('created_at < ?', 30.days.ago).delete_all
end
