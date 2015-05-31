module Qudos
  def self.items
    QudosScraper.new.items
  end

  class QudosScraper
    include Scraper
    def initialize
      @url = 'https://www.qudos.io'
    end

    def items
      [].tap do |items|
        entries.each_with_index do |entry, index|
          next if (reject_item?(item = { redirect_url: redirect_url(entry) }))
          items << complete_item(item, entry, index)
        end
      end
    end

    private

    def entries
      page = Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .css('.entry')
    end

    def redirect_url(entry)
      [@url, entry.at_css('.title')['href'], '/l'].join
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end

    def title(entry)
      [
        entry.at_css('.title').text.strip,
        ' - ',
        entry.at_css('.description').text
      ].join
    end

    def complete_item(item, entry, index)
      item.merge({
        title: title(entry),
        url: final_url(item[:redirect_url]),
        comment_url: item[:redirect_url][0..-3],
        source: 'qudos',
        topped: (index == 0) ? true : false,
        word_count: 0
      })
    end
  end
end
