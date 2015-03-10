require 'open-uri'
require_relative '../../config/environment'

include Scraper

def collect_and_save(sources)
  items = []
  errors = []

  sources.each do |method|
    print method.humanize.titlecase
    begin
      items += Scraper.instance_method((method + '_items').to_sym).bind(self).call
    rescue Exception => e
      print ' - Failed!'
      errors << e
    end
    print "\n"
  end
  Notifier.send(errors) unless errors.empty?

  items.shuffle.each do |item|
    existing = Item.find_by_url(item[:url])
    if existing
      existing.update_attributes(item) if item[:topped] == true
    else
      Item.create(item)
    end
  end
end

task :collect_active do
  item_count = Item.count
  collect_and_save(['hacker_news', 'product_hunt', 'reddit', 'designer_news'])
  puts "Created #{Item.count - item_count} items"
end

task :collect_feeds do
  item_count = Item.count
  collect_and_save(['betalist', 'macrumors', 'qudos', 'github'])
  puts "Created #{Item.count - item_count} items"
end
