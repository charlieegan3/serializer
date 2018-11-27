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
        Airbrake.notify(e) unless e.message == 'ItemTooSimilar'
      end
    end
  end
end

task :collect_active do
  item_count = Item.count
  items = HackerNews.items('https://news.ycombinator.com/', 25)
  items += HackerNews.items('https://news.ycombinator.com/show', 5)
  items += Reddit.items('https://www.reddit.com/r/programming', 10)
  items += Reddit.items('https://www.reddit.com/r/dataisbeautiful', 5)
  items += Reddit.items('https://www.reddit.com/r/Technology', 1)
  items += Reddit.items('https://www.reddit.com/r/science', 1)
  items += Lobsters.items
  save_items(items.flatten)
end

task :collect_feeds do
  item_count = Item.count
  items = ArsTechnica.items
  items += MacRumors.items
  save_items(items.flatten)
end
