require_relative '../../config/environment'

task :monitor_source_collections do
  {
    'hacker_news' => 1.days.ago,
    'product_hunt' => 1.days.ago,
    'reddit' => 1.days.ago,
    'lobsters' => 1.days.ago,
    'slashdot' => 2.days.ago,
    'beta_list' => 2.days.ago,
    'macrumors' => 2.days.ago,
    'qudos' => 8.days.ago,
    'designer_news' => 2.days.ago,
    'arstechnica' => 2.days.ago,
    'computerphile' => 7.days.ago,
    'techcrunch' => 2.days.ago,
  }.each do |source, warning_time|
    if Item.where(source: source)
      .order(created_at: 'DESC')
      .limit(1)
      .last
      .created_at < warning_time
      Airbrake.notify_or_ignore('Notification', parameters: { source: source })
    end
  end
end
