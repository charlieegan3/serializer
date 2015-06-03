module Reddit
  @default_page = 'http://www.reddit.com/r/programming/'
  @default_count = 10

  def self.items(page = @default_page, count = @default_count)
    begin
      RedditScraper.new.items(page, count)
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class RedditScraper
    include Scraper
    def items(page, count)
      [].tap do |items|
        rows(page, count).each_with_index do |row, index|
          (item = row_item(row, index)) ? items << item : next
        end
      end
    end

    def row_item(row, index)
      false if reject_item?(item = { url: row.at_css('a.title')['href'] })
      item.merge!({
        title: row.at_css('a.title').text,
        comment_url: row.at_css('a.comments')['href'],
        source: 'reddit',
        topped: (index == 0) ? true : false,
        word_count: word_count(item[:url])
      })
    end

    private

    def rows(page, count)
      Nokogiri::HTML(open(page), nil, 'UTF-8')
        .css('.entry')
        .take(count)
        .reject { |r| r.text.match(/stickied post|PLEASE READ/) }
    end

    def reject_item?(item)
      !item[:url].match(/http(s|):/) || Item.find_by_url(item[:url]).present?
    end
  end
end
