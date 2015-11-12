module HackerNews
  @default_page = 'https://news.ycombinator.com/'
  @default_count = 25

  def self.items(page = @default_page, count = @default_count)
    begin
      HackerNewsScraper.new.items(page, count)
    rescue => e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class HackerNewsScraper
    include Utilities
    def items(page, count)
      [].tap do |items|
        rows(page, count).each_with_index do |row, index|
          (item = row_item(row[0], row[1], index)) ? items << item : next
        end
      end
    end

    private

    def row_item(link, details, index)
      item = { title: link_title(link), url: link_url(link) }
      return false if reject_item?(item)
      item.merge!(source: 'hacker_news',
                  topped: (index == 0) ? true : false,
                  comment_url: comment_url(details),
                  word_count: word_count(item[:url]))
    end

    def rows(url, count)
      Nokogiri::HTML(open(url).read, nil, 'UTF-8')
        .css('table')[2].css('tr')
        .reject { |tr| non_item_row?(tr) }
        .in_groups_of(2)
        .to_a
        .take(count)
    end

    def link_title(link)
      link.at_css('td:last-child a').text
    end

    def link_url(link)
      url = link.css('td:last-child a').first['href']
      relative_url?(url) ? url.prepend('https://news.ycombinator.com/') : url
    end

    def comment_url(details)
      if details.css('a')
        details.css('a').last['href'].prepend('https://news.ycombinator.com/')
      else
        ''
      end
    end

    def non_item_row?(tr)
      tr.text.blank? ||
        tr.text == 'More' ||
        tr.text.include?('Please read the rules')
    end

    def relative_url?(url)
      url[0...4] != 'http'
    end

    def reject_item?(item)
      if item[:title].downcase.match(/hir(ed|ing)/) ||
         Item.find_by_url(item[:url])
        true
      else
        false
      end
    end
  end
end
