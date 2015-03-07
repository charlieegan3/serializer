require 'open-uri'
require_relative '../../config/environment'

include Scraper

task :collect do
  item_count = Item.count

  items = []
  puts 'Hacker News'
  items += Scraper.hacker_news_items
  puts 'Product Hunt'
  items += Scraper.product_hunt_items
  puts 'Reddit'
  items += Scraper.reddit_items
  puts 'Beta List'
  items += Scraper.betalist_items
  puts 'MacRumors'
  items += Scraper.macrumors_items

  items.each { |item| Item.create(item) }

  puts "Created #{Item.count - item_count} items"
end
