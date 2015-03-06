require 'open-uri'
require_relative '../../config/environment'

task :collect do
  page = Nokogiri::HTML(open('https://news.ycombinator.com'))

  item_count = Item.count
  page.css('td.title > a').map do |item|
    next if item.text == 'More'
    unless item['href'].include?('http')
      item['href'] = 'https://news.ycombinator.com/' + item['href']
    end
    Item.create(url: item['href'], title: item.text.strip)
  end
  puts "Created #{Item.count - item_count} items"
end
