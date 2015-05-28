require 'open-uri'
require_relative '../../config/environment'

include Scraper
include Notifier

def collect_and_save(sources)
  items = []
  errors = []

  sources.each do |method|
    print method.humanize.titlecase
    begin
      items += Scraper
                .instance_method((method + '_items').to_sym)
                .bind(self)
                .call
                .reverse
    rescue Exception => e
      print ' - Failed!'
      errors <<  e.message + "\n\n" + e.backtrace.join("\n")
    end
    print "\n"
  end

  send_errors(errors) unless errors.empty?

  items.each do |item|
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
  collect_and_save(['hacker_news', 'product_hunt', 'reddit', 'designer_news', 'lobsters'])
  puts "Created #{Item.count - item_count} items"
end

task :collect_feeds do
  item_count = Item.count
  collect_and_save(['betalist', 'macrumors', 'qudos', 'arstechnica', 'slashdot', 'computerphile', 'techcrunch'])
  puts "Created #{Item.count - item_count} items"
end

task :set_tweet_counts do
  Item.where("created_at > ?", 30.minutes.ago).each do |item|
    count = JSON.parse(open("http://urls.api.twitter.com/1/urls/count.json?url=#{item.url}").read)['count'] rescue next
    item.update_attribute(:tweet_count, count.to_i)
    puts "#{item.title[0..19].ljust(20)} - #{item.tweet_count}"
  end
end
