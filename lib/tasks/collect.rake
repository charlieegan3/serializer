require 'open-uri'
require_relative '../../config/environment'

include Scraper

task :collect do
  item_count = Item.count

  errors = []
  items = Scraper.instance_methods.inject([]) do |items, method|
    print method.to_s[0..-7].humanize.titlecase
    begin
      items += Scraper.instance_method(method).bind(self).call
    rescue Exception => e
      print ' - Failed!'
      errors << e
    end
    print "\n"
  end

  Notifier.send(errors) unless errors.empty?

  items.each { |item| Item.create(item) } if items

  puts "Created #{Item.count - item_count} items"
end
