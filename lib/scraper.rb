module Scraper
  def hacker_news_items
    page = Nokogiri::HTML(open('https://news.ycombinator.com'), nil, 'UTF-8')
    [].tap do |items|
      page.css('td.title > a').map do |item|
        next if item.text == 'More'
        unless item['href'].include?('http')
          item['href'] = 'https://news.ycombinator.com/' + item['href']
        end
        items << {title: item.text.strip, url: item['href'], source: 'hacker_news'}
      end
    end
  end

  def product_hunt_items
    httpc = HTTPClient.new
    page = Nokogiri::HTML(open('http://www.producthunt.com'), nil, 'UTF-8')
    [].tap do |items|
      page.at_css('.posts-group').css('.url').map do |post|
        items << {
          title: post.at_css('.title').text + ' - ' + post.at_css('.post-tagline').text,
          url: httpc.get('http://www.producthunt.com' + post.at_css('.title')['href']).header['Location'].first.to_s,
          source: 'product_hunt'
        }
      end
    end
  end

  def reddit_items
    page = Nokogiri::HTML(open('http://www.reddit.com/r/programming/'), nil, 'UTF-8')
    [].tap do |items|
      page.css('a.title').reverse.map do |link|
        items << {title: link.text, url: link['href'], source: 'reddit'}
      end
    end
  end

  def betalist_items
    httpc = HTTPClient.new
    feed = Feedjira::Feed.fetch_and_parse('http://feeds.feedburner.com/betalist?format=xml')
    [].tap do |items|
      feed.entries.each do |entry|
        items << {
          title: entry.title + ' - ' + Nokogiri::HTML(entry.content).text.split(/,|\./).first,
          url: httpc.get(entry.id + '/visit').header['Location'].first.to_s,
          source: 'beta_list'
        }
      end
    end
  end

  def macrumors_items
    feed = Feedjira::Feed.fetch_and_parse('http://feeds.macrumors.com/MacRumors-Front')
    [].tap do |items|
      feed.entries.each do |entry|
        items << {title: entry.title, url: entry.url, source: 'macrumors'}
      end
    end
  end

  def qudos_items
    httpc = HTTPClient.new
    page = Nokogiri::HTML(open('https://www.qudos.io'), nil, 'UTF-8')
    [].tap do |items|
      page.css('.grid-90').map do |item|
        items << {
          title: item.at_css('.title').text + ' - ' + item.at_css('.description').text,
          url: httpc.get('https://www.qudos.io' + item.at_css('.title')['href']).header['Location'].first.to_s,
          source: 'qudos'
        }
      end
    end
  end
end
