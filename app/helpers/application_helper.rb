module ApplicationHelper
  def time_ago(time)
    (distance_of_time_in_words(time, Time.new) + ' ago').
      gsub('about', '').
      gsub('hours', 'hrs').
      gsub('minutes', 'mins').
      gsub('less than a', '1').
      strip
  end

  def print_url(url)
    url.split('/')[2].gsub('www.', '')
  end
end
