if ENV["ENABLE_SCHEDULER"].present?
  require "rufus-scheduler"
  require "rake"

  Rails.application.load_tasks unless Rake::Task.tasks.any?

  scheduler = Rufus::Scheduler.new

  collect_interval = ENV.fetch("COLLECT_INTERVAL", "1m")
  clean_interval = ENV.fetch("CLEAN_INTERVAL", "2m")
  graph_interval = ENV.fetch("GRAPH_INTERVAL", "3m")

  def invoke_reenable(task_name)
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  rescue => e
    Rails.logger.error("Scheduler task #{task_name} failed: #{e.message}")
  end

  scheduler.every collect_interval, overlap: false do
    Rails.logger.info "Invoking collect_active task"
    invoke_reenable("collect_active")
  end

  scheduler.every collect_interval, overlap: false do
    Rails.logger.info "Invoking collect_feeds task"
    invoke_reenable("collect_feeds")
  end

  scheduler.every clean_interval, overlap: false do
    Rails.logger.info "Invoking clean_old_data task"
    invoke_reenable("clean_old_data")
  end

  scheduler.every graph_interval, overlap: false do
    Rails.logger.info "Invoking save_graph task"
    invoke_reenable("save_graph")
  end

  Rails.logger.info "Rufus::Scheduler started with intervals: active=#{collect_interval}, clean=#{clean_interval}, graph=#{graph_interval}"
end
