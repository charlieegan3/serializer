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
  items += Reddit.items('http://www.reddit.com/r/programming/', 10)
  items += Reddit.items('http://www.reddit.com/r/dataisbeautiful/', 5)
  items += Reddit.items('http://www.reddit.com/r/Technology', 1)
  items += Reddit.items('http://www.reddit.com/r/science/', 1)
  items += ProductHunt.items
  items += DesignerNews.items
  items += Lobsters.items
  save_items(items.flatten)
end

task :collect_feeds do
  item_count = Item.count
  items = ArsTechnica.items
  items += BetaList.items
  items += Computerphile.items
  items += MacRumors.items
  items += Qudos.items
  items += Slashdot.items
  items += Techcrunch.items
  save_items(items.flatten)
end

task :set_tweet_counts do
  Item.where('created_at > ?', 30.minutes.ago).each do |item|
    count = JSON
            .parse(
              open(
                "http://urls.api.twitter.com/1/urls/count.json?url=#{item.url}"
              )
              .read
            )['count'] rescue next
    item.update_attribute(:tweet_count, count.to_i)
  end
end
