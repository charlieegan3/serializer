require 'timeout'

module Utilities
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
    # TODO
    return 0
  end
end
