require_relative '../../config/environment'

task :clean_old_data do
  Session.where('updated_at < ?', 2.days.ago).delete_all
  Session.where(read_count: nil).delete_all
  Item.where('created_at < ?', 5.days.ago).delete_all
end
