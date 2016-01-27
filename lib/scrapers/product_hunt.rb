module ProductHunt
  def self.items
    begin
      ProductHuntScraper.new.items
    rescue => e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class ProductHuntScraper
    include Utilities
    def initialize
      @url = 'https://www.producthunt.com/tech'
      @base_url = 'https://www.producthunt.com'
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
      JSON.parse(
        Nokogiri::HTML(open(@url), nil, 'UTF-8')
          .css('div[data-react-class="App"]').last['data-react-props']
      )["component_data"]["post_groups"]
        .map {|g| g["posts"]}
        .flatten
        .take(30)
        .map do |p|
          {
            title: p["name"],
            url: @base_url + p["url"],
            redirect_url: @base_url + p["shortened_url"],
            tagline: p["tagline"]
          }
        end
    end

    def reject_item?(item)
      Item.find_by_redirect_url(item[:redirect_url]).present?
    end

    def complete_item(item, post, index)
      item.merge(title: "#{post[:title]} - #{post[:tagline]}",
                 url: final_url(post[:redirect_url]),
                 comment_url: post[:url],
                 source: 'product_hunt',
                 topped: (index == 0) ? true : false,
                 word_count: 0)
    end
  end

end
