class RedditScraper
  include Scraper
  def initialize
    @pages = [
      { url: 'http://www.reddit.com/r/programming/', count: 10 },
      { url: 'http://www.reddit.com/r/dataisbeautiful/', count: 5 },
      { url: 'http://www.reddit.com/r/Technology',  count:1 },
      { url: 'http://www.reddit.com/r/science/', count: 1 }
    ]
  end

  def items
    [].tap do |items|
      @pages.each do |page|
        rows(page[:url], page[:count]).each_with_index do |row, index|
          (item = row_item(row, index)) ? items << item : next
        end
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

  def rows(url, count)
    Nokogiri::HTML(open(url), nil, 'UTF-8')
      .css('.entry')
      .take(count)
      .reject { |r| r.text.match(/stickied post|PLEASE READ/) }
  end

  def reject_item?(item)
    !item[:url].match(/http(s|):/) || Item.find_by_url(item[:url]).present?
  end
end
