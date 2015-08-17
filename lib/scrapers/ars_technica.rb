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
    include Utilities
    def initialize
      @url = 'http://feeds.arstechnica.com/arstechnica/index'
    end

    def items
      [].tap do |items|
        entries.each do |entry|
          next if reject_item?(item = {
            title: entry.title,
            redirect_url: redirect_url(entry)
          })
          item[:url] = final_url(item[:redirect_url])
          items << item.merge(source: 'arstechnica',
                              word_count: word_count(item[:url]))
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
      Item.find_by_redirect_url(item[:redirect_url]).present? ||
      item[:title].downcase.include?('dealmaster')
    end
  end
end
