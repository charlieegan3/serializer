def designer_news_items
  page = Nokogiri::HTML(open('https://news.layervault.com'), nil, 'UTF-8')
  [].tap do |items|
    page.css('.Story').each_with_index do |story, index|
      link = story.at_css('a')
      link.at_css('.Domain').remove if link.at_css('.Domain')
      redirect_url = link['href'].gsub('https', 'http')
      next if Item.find_by_redirect_url(redirect_url)
      url = final_url(redirect_url).split('#').first
      items << {
        title: link.text.strip,
        url: url,
        comment_url: 'https://news.layervault.com' + story.css('.PointCount > a').first['href'],
        redirect_url: redirect_url,
        source: 'designer_news',
        topped: (index == 0) ? true : false,
        word_count: word_count(url),
      }
    end
  end
end

class DesignerNewsScraper
  include Scraper

  def initialize
    @url = 'https://news.layervault.com'
  end

  def items
    [].tap do |items|
      stories.each_with_index do |story, index|
        next if reject_item?(item = { redirect_url: redirect_url(story) })
        items << complete_item(item, story, index)
      end
    end
  end

  private

  def stories
    Nokogiri::HTML(open('https://news.layervault.com'), nil, 'UTF-8')
      .css('.Story')
  end

  def redirect_url(story)
    story.at_css('.Domain').remove if story.at_css('.Domain')
    story.at_css('a')['href'].gsub('https', 'http')
  end

  def reject_item?(item)
    Item.find_by_redirect_url(item[:redirect_url]).present?
  end

  def url(item)
    final_url(item[:redirect_url]).split('#').first
  end

  def title(story)
    story.at_css('a').text.strip
  end

  def comment_url(story)
    @url + story.css('.PointCount > a').first['href']
  end

  def complete_item(item, story, index)
    item = item.merge({
      title: title(story),
      url: final_url(item[:redirect_url]),
      comment_url: comment_url(story),
      source: 'designer_news',
      topped: (index == 0) ? true : false,
    })
    item.merge(word_count: word_count(item[:url]))
  end
end
