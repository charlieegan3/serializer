require 'open-uri'
require_relative '../../config/environment'

include Scraper

task :collect do
  item_count = Item.count

  items = Scraper.instance_methods.inject([]) do |items, method|
    puts method.to_s[0..-7].humanize.titlecase
    items += Scraper.instance_method(method).bind(self).call rescue []
  end

  items.each { |item| Item.create(item) }

  puts "Created #{Item.count - item_count} items"
end
