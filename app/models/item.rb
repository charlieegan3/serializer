class Item < ActiveRecord::Base
  validates_uniqueness_of :url

  before_save :truncate_title
  def truncate_title
    self.title = self.title[0..140] + '...' if self.title.length > 140
  end

  def self.matching(sources = ['hacker_news', 'reddit', 'product_hunt'])
    where(source: sources).
      limit(150).
      order(created_at: 'DESC')
  end

  def self.day_count
    where('created_at >= ?', Time.zone.now - 1.days).size
  end

  def self.eight_hour_count
    where('created_at >= ?', Time.zone.now - 8.hours).size
  end

  def self.hour_count
    where('created_at >= ?', Time.zone.now - 1.hours).size
  end
end
