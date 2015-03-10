module Scraper
  def hacker_news_items
    page = Nokogiri::HTML(open('https://news.ycombinator.com/news'), nil, 'UTF-8')
    [].tap do |items|
      page.css('table')[2].css('tr').reject { |x| x.text.blank? || x.text == 'More' }.in_groups_of(2) do |link, details|
        title = link.css('td:last-child a').first.text
        url = link.css('td:last-child a').first['href']
        unless url.include?('http')
          url = 'https://news.ycombinator.com/' + url
        end
        comment_url = 'https://news.ycombinator.com/' + details.css('a').last['href'] rescue ''
        items << {title: title, url: url, comment_url: comment_url ,source: 'hacker_news'}
      end
      items.first.merge!({topped: true})
    end
  end

  def product_hunt_items
    httpc = HTTPClient.new
    page = Nokogiri::HTML(open('http://www.producthunt.com'), nil, 'UTF-8')
    [].tap do |items|
      page.at_css('.posts-group').css('.post--content').each do |item|
        link = item.at_css('.url')
        items << {
          title: link.at_css('.title').text + ' - ' + link.at_css('.post-tagline').text,
          url: httpc.get('http://www.producthunt.com' + link.at_css('.title')['href']).header['Location'].first.to_s,
          comment_url: 'http://www.producthunt.com' + item['data-href'],
          source: 'product_hunt'
        }
      end
      items.first.merge!({topped: true})
    end
  end

  def reddit_items
    page = Nokogiri::HTML(open('http://www.reddit.com/r/programming/'), nil, 'UTF-8')
    [].tap do |items|
      page.css('a.title').map do |link|
        items << {title: link.text, url: link['href'], source: 'reddit'}
      end
      items.first.merge!({topped: true})
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
      items.first.merge!({topped: true})
    end
  end

  def designer_news_items
    httpc = HTTPClient.new
    page = Nokogiri::HTML(open('https://news.layervault.com'), nil, 'UTF-8')
    [].tap do |items|
      page.css('.Story > a').each do |story|
        story.at_css('.Domain').remove if story.at_css('.Domain')
        items << {
          title: story.text.strip,
          url: httpc.get(story['href']).header['Location'].first.to_s,
          source: 'designer_news'
        }
      end
      items.first.merge!({topped: true})
    end
  end

  def github_items
    feed = Feedjira::Feed.fetch_and_parse('http://github-trends.ryotarai.info/rss/github_trends_all_daily.rss')
    [].tap do |items|
      feed.entries.each do |entry|
        items << {
          title: entry.title.gsub(/\s+\(.*\)/, '') + ' - ' + entry.summary.gsub(/\s+/, ' ').gsub('()', '').strip,
          url: entry.url,
          source: 'github'
        }
      end
    end
  end
end
