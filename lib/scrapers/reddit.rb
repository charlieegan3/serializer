module Reddit
  @default_page = 'https://www.reddit.com/r/programming'
  @default_count = 10

  def self.items(page = @default_page, count = @default_count)
    begin
      RedditScraper.new.items(page, count)
    rescue => e
      puts e.message
      return []
    end
  end

  class RedditScraper
    include Utilities
    def items(page, count)
      [].tap do |items|
        rows(page, count).each_with_index do |row, index|
          (item = row_item(row, index)) ? items << item : next
        end
      end
    end

    def row_item(row, index)
      item = { url: row["data"]["url"] }
      return false if reject_item?(item)
      puts row["data"]["url"]
      item.merge!(title: row["data"]["title"],
                  comment_url: "https://reddit.com" + row["data"]["permalink"],
                  source: 'reddit',
                  topped: (index == 0) ? true : false,
                  word_count: word_count(item[:url]))
    end

    private

    def rows(page, count)
      JSON.parse(URI.open(page + ".json", 'User-Agent' => 'Chrome').read)
        .dig("data", "children")
        .reject { |r| r["data"]["title"].match(/stickied post|PLEASE READ/) }
        .reject { |r| r["data"]["stickied"] }
        .take(count)
    end

    def reject_item?(item)
      !item[:url].match(/http(s|):/) || Item.find_by_url(item[:url]).present?
    end
  end
end
