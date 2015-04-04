class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_uniqueness_of :redirect_url

  before_save :truncate_title, :prevent_duplicates, :remove_content_tag
  def truncate_title
    self.title = self.title[0..140] + '...' if self.title && self.title.length > 140
  end

  def prevent_duplicates
    Item.where('created_at >= ?', Time.zone.now - 1.days).each do |item|
      return false if Jaccard.coefficient(title_list, item.title_list) > 0.8
    end
  end

  def remove_content_tag
    # if self.title for shoulda is annoying
    self.title = self.title.gsub(/\s*\[[a-zA-Z]+\]$/, '') if self.title
  end

  def title_list
    title.gsub(/\W+/, ' ').downcase.strip.split(' ')
  end

  def reading_time
    self.word_count.to_i / 300
  end

  def format
    return 'pdf' if self.url.match(/\.pdf$/)
    return 'img' if self.url.match(/(\.png$|\.jpg$|\.gif$)/)
  end

  def self.matching(sources = ['hacker_news', 'reddit', 'product_hunt'])
    where(source: sources).
      limit(150).
      order(created_at: 'DESC')
  end

  def self.default
    all.order(created_at: 'DESC').limit(300)
  end

  def self.average_hour_count(sources)
    where(source: sources).
      where('created_at >= ?', Time.zone.now - 1.days).
      size / 24
  end
end
