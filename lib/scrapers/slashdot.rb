module Slashdot
  def self.items
    SlashdotScraper.new.items
  end

  class SlashdotScraper
    include Scraper
    def initialize
      @url = 'http://technology.slashdot.org'
    end

    def items
      [].tap do |items|
        links.each do |link|
          items << {
            title: link.text.strip,
            url: url(link),
            source: 'slashdot',
            word_count: word_count(url(link))
          }
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
  end
end
