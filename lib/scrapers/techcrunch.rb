module Techcrunch
  def self.items
    begin
      TechcrunchScraper.new.items
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class TechcrunchScraper
    include Scraper
    def initialize
      @url = 'http://techcrunch.com/startups/'
    end

    def items
      [].tap do |items|
        blocks.each do |block|
          next if reject_item?(item = { url: block['data-permalink'] })
          items << {
            title: block['data-sharetitle'],
            comment_url: block.at_css('a.comment')['href'],
            source: 'techcrunch',
            word_count: word_count(block['data-permalink'])
          }
        end
      end
    end

    private

    def blocks
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .css('.river > .river-block')
    end

    def reject_item?(item)
      Item.find_by_url(item[:url]).present?
    end
  end
end
