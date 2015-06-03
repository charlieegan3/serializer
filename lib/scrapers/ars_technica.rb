module ArsTechnica
  def self.items
    begin
      ArsTechnicaScraper.new.items
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class ArsTechnicaScraper
    include Scraper
    def initialize
      @url = 'http://feeds.arstechnica.com/arstechnica/index'
    end

    def items
      [].tap do |items|
        entries.each do |entry|
          next if reject_item?(item = { redirect_url: redirect_url(entry) })
          item[:url] = final_url(item[:redirect_url])
          items << item.merge({
            title: entry.title,
            source: 'arstechnica',
            word_count: word_count(item[:url])
          })
        end
      end

    end

    private

    def entries
      Feedjira::Feed.fetch_and_parse(@url).entries
    end

    def redirect_url(entry)
      entry.entry_id.gsub('https', 'http')
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end
  end

end
