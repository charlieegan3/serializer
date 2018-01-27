require 'open-uri'
require_relative '../../config/environment'

def save_items(items)
  items.each do |item|
    existing = Item.find_by_url(item[:url])
    if existing
      existing.update_attributes(item) if item[:topped] == true
    else
      begin
        Item.create!(item)
      rescue => e
        Airbrake.notify_or_ignore(e) unless e.message == 'ItemTooSimilar'
      end
    end
  end
end

task :collect_active do
  item_count = Item.count
  items = HackerNews.items('https://news.ycombinator.com/', 25)
  items += HackerNews.items('https://news.ycombinator.com/show', 5)
  save_items(items.flatten)
end
