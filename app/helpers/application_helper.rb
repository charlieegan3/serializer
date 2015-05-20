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

  def unread_count(items, session)
    if session.completed_to
      unread = items.reject { |x| x.created_at < session.completed_to }.size
    else
      unread = items.size
    end
    (unread > 0)? "#{unread} new - serializer" : nil
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
