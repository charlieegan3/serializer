require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

scheduler.every '10m' do
  `rake collect_active`
end

scheduler.every '60m' do
  `rake collect_feeds`
end
