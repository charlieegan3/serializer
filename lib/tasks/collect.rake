require 'open-uri'
require_relative '../../config/environment'

include Scraper

task :collect do
  item_count = Item.count

  items = []
  items += Scraper.hacker_news_items rescue []
  items += Scraper.product_hunt_items rescue []
  items += Scraper.reddit_items rescue []
  items += Scraper.betalist_items rescue []
  items += Scraper.macrumors_items rescue []
  items += Scraper.qudos_items rescue []

  items.each { |item| Item.create(item) }

  puts "Created #{Item.count - item_count} items"
end
