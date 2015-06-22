require 'rufus-scheduler'

if Rails.env.production?
  scheduler = Rufus::Scheduler.singleton

  scheduler.every '10m' do
    `rake collect_active`
  end

  scheduler.every '10m' do
    `rake set_tweet_counts`
  end

  scheduler.every '1h' do
    `rake collect_feeds`
  end

  scheduler.every '1h' do
    `rake save_graph`
  end

  scheduler.every '1d' do
    `rake clean_inactive_sessions`
  end

  scheduler.every '1d' do
    `rake monitor_source_collections`
  end
end
