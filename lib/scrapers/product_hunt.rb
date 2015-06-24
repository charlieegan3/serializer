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
          next if reject_item?(item = { redirect_url: post[:redirect_url] })
          items << complete_item(item, post, index)
        end
      end
    end

    private

    def posts
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .at_css('.posts--group')
        .css('.post-item').map do |p|
          title = p.at_css('.post-item--text--name')
          {
            title: title.text,
            redirect_url: @url + title['href'],
            comment_url: @url + p.at_css('.post-item--comments')['href'],
            tagline: p.at_css('.post-item--text--tagline').text
          }
      end
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end

    def complete_item(item, post, index)
      item.merge(title: "#{post[:title]} - #{post[:tagline]}",
                 url: final_url(post[:redirect_url]),
                 source: 'product_hunt',
                 topped: (index == 0) ? true : false,
                 word_count: 0)
    end
  end

end
