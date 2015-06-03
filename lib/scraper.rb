require 'timeout'

module Scraper
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
    print '/'
    return 0 if url.match(/combinator|reddit\.com|layervault|lobste\.rs/)
    return 0 if url.match(/\.(jpg|gif|png|pdf)$/)
    begin
      status = Timeout::timeout(2) {
        extractor = Extractor.new(open(url, :allow_redirections => :all).read, url)
        extractor.word_count.to_i
      }
    rescue
      print '*'
      return 0
    end
  end
end
