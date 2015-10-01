module Computerphile
  def self.items
    begin
      ComputerphileScraper.new.items
    rescue => e
      Airbrake.notify_or_ignore(e)
      return []
    end
  end

  class ComputerphileScraper
    include Utilities
    def initialize
      @url = 'https://www.youtube.com/user/Computerphile/videos?flow=list&view=54'
    end

    def items
      [].tap do |items|
        videos.each do |video|
          items << {
            title: parse_text(video).first,
            url: url(video),
            source: 'computerphile',
            word_count: minute_duration(parse_text(video).last)
          }
        end
      end
    end

    private

    def videos
      Nokogiri::HTML(open(@url), nil, 'UTF-8')
        .css('.yt-lockup-title')
    end

    def url(video)
      video.at_css('a')['href'].prepend('https://www.youtube.com')
    end

    def parse_text(video)
      text = video.text.split(/(\s|-)+Computerphile(\s|-)+/)
      [text.first, text.last]
    end

    def minute_duration(duration_string)
      duration_array = duration_string.scan(/[0-9]+/)
      minutes = (duration_array.size > 1) ? 1 : 0
      minutes += duration_array.first.to_i
      minutes *= 300 # translate minutes to equivalent word count
    end
  end

end
