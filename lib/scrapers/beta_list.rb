module BetaList
  def self.items
    BetaListScraper.new.items
  end

  class BetaListScraper
    include Scraper
    def initialize
      @url = 'http://feeds.feedburner.com/betalist?format=xml'
    end

    def items
      [].tap do |items|
        entries.each do |entry|
          next if reject_item?(item = { redirect_url: redirect_url(entry) })
          items << item.merge({
            title: title(entry),
            url: final_url(item[:redirect_url]),
            source: 'beta_list',
            word_count: 0
          })
        end
      end
    end

    private

    def entries
      Feedjira::Feed.fetch_and_parse(@url).entries
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end

    def redirect_url(entry)
      (entry.id + '/visit').gsub('https', 'http')
    end

    def title(entry)
      [
        entry.title,
        ' - ',
        Nokogiri::HTML(entry.content).text.split('. ').first
      ].join
    end
  end

end
