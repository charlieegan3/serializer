module Lobsters
  def self.items
    begin
      LobstersScraper.new.items
    rescue => e
      Airbrake.notify(e)
      return []
    end
  end

  class LobstersScraper
    include Utilities
    def initialize
      @url = 'https://lobste.rs'
    end

    def items
      [].tap do |items|
        stories.each_with_index do |story, index|
          next if reject_item?(item = { title: title(story), url: url(story) })
          items << complete_item(item, story, index)
        end
      end
    end

    private

    def stories
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .css('.story')
    end

    def title(story)
      story.at_css('.link a').text
    end

    def url(story)
      href = story.at_css('.link a')['href']
      (href[0] == '/') ? href.prepend(@url) : href
    end

    def reject_item?(item)
      item[:title].downcase.include?('working on this week') ||
        Item.find_by_url(item[:url]).present?
    end

    def comment_url(story)
      if (a = story.at_css('.comments_label a')).present?
        a['href'].prepend(@url)
      else
        story['data-shortid'].prepend(@url + '/s/')
      end
    end

    def complete_item(item, story, index)
      item.merge(comment_url: comment_url(story),
                 source: 'lobsters',
                 topped: (index == 0) ? true : false,
                 word_count: word_count(item[:url]))
    end
  end
end
