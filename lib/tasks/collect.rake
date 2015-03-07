require 'open-uri'
require_relative '../../config/environment'

task :collect do
  Item.delete_all

  item_count = Item.count

  httpc = HTTPClient.new

  # Hacker News
  page = Nokogiri::HTML(open('https://news.ycombinator.com'), nil, 'UTF-8')
  page.css('td.title > a').map do |item|
    next if item.text == 'More'
    unless item['href'].include?('http')
      item['href'] = 'https://news.ycombinator.com/' + item['href']
    end
    Item.create(url: item['href'], title: item.text.strip, source: 'hacker_news')
  end

  # Product Hunt
  page = Nokogiri::HTML(open('http://www.producthunt.com'), nil, 'UTF-8')
  page.at_css('.posts-group').css('.url').map do |post|
    Item.create(
      title: post.at_css('.title').text + ' - ' + post.at_css('.post-tagline').text,
      url: httpc.get('http://www.producthunt.com' + post.at_css('.title')['href']).header['Location'].first.to_s,
      source: 'product_hunt'
    )
  end

  puts "Created #{Item.count - item_count} items"
end
