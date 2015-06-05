module Slashdot
  def self.items
    begin
      SlashdotScraper.new.items
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class SlashdotScraper
    include Utilities
    def initialize
      @url = 'http://technology.slashdot.org'
    end

    def items
      [].tap do |items|
        links.each do |link|
          next if reject_item?(item = { url: url(link) })
          items << item.merge(title: link.text.strip,
                              source: 'slashdot',
                              word_count: word_count(url(link)))
        end
      end
    end

    private

    def links
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .css('h2.story a')
    end

    def url(link)
      link['href'].prepend('http:')
    end

    def reject_item?(item)
      Item.find_by_url(item[:url]).present?
    end
  end
end
