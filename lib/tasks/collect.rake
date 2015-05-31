require 'open-uri'
require_relative '../../config/environment'

include Scraper
include Notifier

def collect_and_save(sources)
  items = []
  sources.each do |source|
    puts source.class
    begin
      items += source.send(:items)
    rescue
      puts("send error")
    end
  end

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
  collect_and_save([HackerNewsScraper.new,
                    ProductHuntScraper.new,
                    RedditScraper.new,
                    DesignerNewsScraper.new,
                    LobstersScraper.new])
  puts "Created #{Item.count - item_count} items"
end

task :collect_feeds do
  item_count = Item.count

  collect_and_save([BetaListScraper.new,
                    MacRumorsScraper.new,
                    QudosScraper.new,
                    SlashdotScraper.new,
                    ComputerphileScraper.new,
                    TechcrunchScraper.new])
  puts "Created #{Item.count - item_count} items"
end

task :set_tweet_counts do
  Item.where("created_at > ?", 30.minutes.ago).each do |item|
    count = JSON.parse(open("http://urls.api.twitter.com/1/urls/count.json?url=#{item.url}").read)['count'] rescue next
    item.update_attribute(:tweet_count, count.to_i)
    puts "#{item.title[0..19].ljust(20)} - #{item.tweet_count}"
  end
end
