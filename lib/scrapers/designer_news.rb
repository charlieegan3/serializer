module DesignerNews
  def self.items
    begin
      DesignerNewsScraper.new.items
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class DesignerNewsScraper
    include Utilities
    def initialize
      @url = 'https://www.designernews.co'
    end

    def items
      [].tap do |items|
        stories.each_with_index do |story, index|
          item = { redirect_url: redirect_url(story) }
          next if reject_item?(item, story.text)
          items << complete_item(item, story, index)
        end
      end
    end

    private

    def stories
      Nokogiri::HTML(open('https://news.layervault.com'), nil, 'UTF-8')
        .css('.story-details')
    end

    def redirect_url(story)
      story.at_css('.story-domain').remove if story.at_css('.story-domain')
      story.at_css('a')['href'].gsub('https', 'http')
    end

    def reject_item?(item, text)
      Item.find_by_redirect_url(item[:redirect_url]).present? ||
        !text.include?('comments')
    end

    def url(item)
      final_url(item[:redirect_url]).split('#').first
    end

    def title(story)
      story.at_css('a').text.strip
    end

    def comment_url(story)
      @url + story.at_css('.comment-count')['href']
    end

    def complete_item(item, story, index)
      item = item.merge(title: title(story),
                        url: final_url(item[:redirect_url]),
                        comment_url: comment_url(story),
                        source: 'designer_news',
                        topped: (index == 0) ? true : false)
      item.merge(word_count: word_count(item[:url]))
    end
  end

end
