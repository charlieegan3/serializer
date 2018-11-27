module MacRumors
  def self.items
    begin
      MacRumorsScraper.new.items
    rescue => e
      puts e.message
      return []
    end
  end

  class MacRumorsScraper
    include Utilities
    def initialize
      @url = 'http://feeds.macrumors.com/MacRumors-Front'
    end

    def items
      [].tap do |items|
        entries.each do |entry|
          next if reject_item?(item = { url: entry.url })
          items << item.merge(title: entry.title,
                              source: 'macrumors',
                              word_count: word_count(item[:url]))
        end
      end
    end

    private

    def entries
      Feedjira::Feed.fetch_and_parse(@url).entries
    end

    def reject_item?(item)
      Item.find_by_url(item[:url]).present?
    end
  end
end
