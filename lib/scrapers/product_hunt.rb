module ProductHunt
  def self.items
    begin
      ProductHuntScraper.new.items
    rescue => e
      puts e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class ProductHuntScraper
    include Utilities
    def initialize
      @url = 'http://www.producthunt.com'
    end

    def items
      [].tap do |items|
        posts.each_with_index do |post, index|
          next if reject_item?(item = { redirect_url: redirect_url(post) })
          items << complete_item(item, post, index)
        end
      end
    end

    private

    def posts
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .at_css('.posts--group')
        .css('.post--content')
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end

    def redirect_url(post)
      @url + post.at_css('.title')['href']
    end

    def complete_item(item, post, index)
      item.merge(title: title(post),
                 url: final_url(item[:redirect_url]),
                 redirect_url: item[:redirect_url],
                 comment_url: comment_url(post),
                 source: 'product_hunt',
                 topped: (index == 0) ? true : false,
                 word_count: 0)
    end

    def title(post)
      post.at_css('.title').text + ' - ' + post.at_css('.post-tagline').text
    end

    def comment_url(post)
      @url + post['data-href']
    end
  end

end
