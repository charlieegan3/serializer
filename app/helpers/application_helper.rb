module ApplicationHelper
  def time_ago(time)
    (distance_of_time_in_words(time, Time.new)).
      gsub('about', '').
      gsub('less than a', '1').
      gsub(/ minutes*/, 'm').
      gsub(/ hours*/, 'h').
      gsub(/ days*/, 'd').
      strip
  end

  def print_url(url, limit=100)
    begin
      url = url.split('/')[2].
        gsub('www.', '').
        gsub(/\?.*$/, '')
      return url[0..limit] + '...' if url.length > limit
    rescue
      return url
    end
    url
  end
end
