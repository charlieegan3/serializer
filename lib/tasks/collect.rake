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

task :update_hn_statuses do
  Item.where('created_at > ?', 5.hours.ago).each do |item|
    begin
      url = item.url.split('//').last.gsub(/\W/, '%20')
      count = JSON.parse(
        open("https://hn.algolia.com/api/v1/search?tags=story&numericFilters=created_at_i%3E#{(Date.today - 365).to_time.to_i}&query=#{url}").read
      )['nbHits']
      item.update_attribute(:hn_status, count == 0)
    rescue
      next
    end
  end
end
