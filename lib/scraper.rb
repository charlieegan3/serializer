module Scraper
  def hacker_news_items
    [].tap do |items|
      [
        ['https://news.ycombinator.com/news', 30],
        ['https://news.ycombinator.com/show', 15]
      ].each do |page, count|
        Nokogiri::HTML(open(page), nil, 'UTF-8').css('table')[2].css('tr').
        reject { |tr| tr.text.blank? || tr.text == 'More' || tr.text.include?('Please read the rules') }.
        in_groups_of(2).to_a.take(count).each do |link, details|
          title = link.css('td:last-child a').first.text
          url = link.css('td:last-child a').first['href']
          unless url.include?('http')
            url = 'https://news.ycombinator.com/' + url
          end
          next if title.downcase.match(/yc.*hiring/) #yep, here I do what I want
          next if Item.find_by_url(url)
          comment_url = 'https://news.ycombinator.com/' + details.css('a').last['href'] rescue ''
          items << {
            title: title,
            url: url,
            comment_url: comment_url,
            source: 'hacker_news',
            word_count: word_count(url)
          }
        end
        items.first.merge!({topped: true}) unless items.empty?
      end
    end
  end

  def product_hunt_items
    page = Nokogiri::HTML(open('http://www.producthunt.com'), nil, 'UTF-8')
    [].tap do |items|
      page.at_css('.posts--group').css('.post--content').each do |item|
        link = item.at_css('.url')
        redirect_url = 'http://www.producthunt.com' + link.at_css('.title')['href'].gsub('https', 'http')
        next if Item.find_by_redirect_url(redirect_url)
        items << {
          title: link.at_css('.title').text + ' - ' + link.at_css('.post-tagline').text,
          url: final_url(redirect_url),
          comment_url: 'http://www.producthunt.com' + item['data-href'],
          redirect_url: redirect_url,
          source: 'product_hunt',
          word_count: 0
        }
      end
      items.first.merge!({topped: true}) unless items.empty?
    end
  end

  def reddit_items
    [].tap do |items|
      [
        ['http://www.reddit.com/r/programming/', 15],
        ['https://www.reddit.com/r/coding', 10],
        ['http://www.reddit.com/r/ruby+javascript+haskell+cpp+c_programming+go_lang+csharp', 5],
        ['http://www.reddit.com/r/dataisbeautiful/', 5],
        ['http://www.reddit.com/r/Technology', 3],
        ['http://www.reddit.com/r/science/', 3]
      ].each do |page, count|
        Nokogiri::HTML(open(page), nil, 'UTF-8').css('.entry').take(count).each_with_index do |item, index|
          next if item.at_css('a.title').text.include?('PLEASE READ')
          url = item.at_css('a.title')['href']
          next unless url.match(/http(s|):/)
          next if Item.find_by_url(url)
          items << {
            title: item.at_css('a.title').text,
            url: url,
            comment_url: item.at_css('a.comments')['href'],
            source: 'reddit',
            topped: (index == 0)? true : false,
            word_count: word_count(url)
          }
        end
      end
    end
  end

  def designer_news_items
    page = Nokogiri::HTML(open('https://news.layervault.com'), nil, 'UTF-8')
    [].tap do |items|
      page.css('.Story').each do |story|
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
          word_count: word_count(url)
        }
      end
      items.first.merge!({topped: true}) unless items.empty?
    end
  end

  def lobsters_items
    page = Nokogiri::HTML(open('https://lobste.rs'), nil, 'UTF-8')
    [].tap do |items|
      page.css('.details').each do |story|
        url = story.at_css('.link a')['href']
        url.prepend('https://lobste.rs') if url[0] == '/'
        next if Item.find_by_url(url)
        items << {
          title: story.at_css('.link a').text,
          url: url,
          comment_url: (story.at_css('.comments_label a')['href'].prepend('https://lobste.rs') rescue nil),
          source: 'lobsters',
          word_count: word_count(url)
        }
      end
      items.first.merge!({topped: true}) unless items.empty?
    end
  end

  def slashdot_items
    page = Nokogiri::HTML(open('http://technology.slashdot.org'), nil, 'UTF-8')
    [].tap do |items|
      page.css('h2.story a').each do |link|
        url = 'http:' + link['href']
        next if Item.find_by_url(url)
        items << {
          title: link.text.strip,
          url: url,
          comment_url: url,
          redirect_url: url,
          source: 'slashdot',
          word_count: word_count(url)
        }
      end
    end
  end

  def qudos_items
    page = Nokogiri::HTML(open('https://www.qudos.io'), nil, 'UTF-8')
    [].tap do |items|
      page.css('.grid-90').map do |item|
        redirect_url = 'https://www.qudos.io' + item.at_css('.title')['href'].gsub('https', 'http')
        next if Item.find_by_redirect_url(redirect_url)
        items << {
          title: item.at_css('.title').text + ' - ' + item.at_css('.description').text,
          url: final_url(redirect_url),
          redirect_url: redirect_url,
          source: 'qudos',
          word_count: 0
        }
      end
      items.first.merge!({topped: true}) unless items.empty?
    end
  end

  def betalist_items
    feed = Feedjira::Feed.fetch_and_parse('http://feeds.feedburner.com/betalist?format=xml')
    [].tap do |items|
      feed.entries.each do |entry|
        redirect_url = (entry.id + '/visit').gsub('https', 'http')
        next if Item.find_by_redirect_url(redirect_url)
        items << {
          title: entry.title + ' - ' + Nokogiri::HTML(entry.content).text.split(/,|\./).first,
          url: final_url(redirect_url),
          redirect_url: redirect_url,
          source: 'beta_list',
          word_count: 0
        }
      end
    end
  end

  def macrumors_items
    feed = Feedjira::Feed.fetch_and_parse('http://feeds.macrumors.com/MacRumors-Front')
    [].tap do |items|
      feed.entries.each do |entry|
        next if Item.find_by_url(entry.url)
        items << {
          title: entry.title,
          url: entry.url,
          source: 'macrumors',
          word_count: word_count(entry.url)
        }
      end
    end
  end

  def arstechnica_items
    feed = Feedjira::Feed.fetch_and_parse('http://feeds.arstechnica.com/arstechnica/index')
    [].tap do |items|
      feed.entries.each do |entry|
        redirect_url = entry.entry_id.gsub('https', 'http')
        next if Item.find_by_redirect_url(redirect_url)
        url = final_url(redirect_url)
        items << {
          title: entry.title,
          url: url,
          redirect_url: redirect_url,
          source: 'arstechnica',
          word_count: word_count(url)
        }
      end
    end
  end

  private
    def final_url(redirect_url)
      begin
        open(redirect_url, allow_redirections: :all) do |resp|
          return resp.base_uri.to_s
        end
      rescue
        return HTTPClient.new.get(redirect_url).header['Location'].first.to_s
      end
    end

    def word_count(url)
      return 0 if url.match(/\.(jpg|gif|png|pdf)$/)
      extractor = Extractor.new(open(url, :allow_redirections => :all).read, url)
      begin
        extractor.word_count.to_i
      rescue
        puts "Word Count Failed for: #{url}"
        return 0
      end
    end
end
