class Item < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :url
  validates_uniqueness_of :url
  validates_format_of :url, with: %r{http(s)?://}, on: :create
  validates_format_of :title, with: /\w{4,}/, on: :create

  before_save :truncate_title,
              :remove_content_tag,
              :clean_url_parameters

  before_create :prevent_duplicates

  def truncate_title
    return unless self.title && self.title.length > 140
    self.title = self.title[0..140] + '...'
  end

  def prevent_duplicates
    Item.where('created_at >= ?', Time.zone.now - 36.hours).each do |item|
      if Jaccard.coefficient(title_list, item.title_list) > 0.8
        fail 'ItemTooSimilar'
      elsif validation_url == item.validation_url
        fail 'ItemTooSimilar'
      end
    end
  end

  def remove_content_tag
    self.title = self.title.gsub(/\s*\[[a-zA-Z]+\]$/, '') if title
  end

  def clean_url_parameters
    self.url = self.url.gsub(/(\?|&)utm[^&]*/, '?')
      .gsub('?&', '?')
      .gsub(/\?+/, '?')
      .gsub(/(\?)?ref=\w+/, '')
  end

  def validation_url
    url.gsub(%r{http(s)?://(www\.)?}, '').gsub(/\W/, '')
  end

  def title_list
    title.gsub(/\W+/, ' ').downcase.strip.split(' ')
  end

  def reading_time
    (word_count.to_f / 300).ceil
  end

  def age
    ApplicationController.helpers
      .distance_of_time_in_words(created_at, Time.new)
      .gsub('about', '')
      .gsub('less than a', '1')
      .gsub(/ minutes*/, 'm')
      .gsub(/ hours*/, 'h')
      .gsub(/ days*/, 'd')
      .strip
  end

  def format
    return 'pdf' if url.match(/\.pdf$/)
    return 'img' if url.match(/(\.png$|\.jpg$|\.gif$)/)
  end

  def reading_kind
    url.match(/youtube|youtu\.be/) ? 'watch' : 'read'
  end

  def trello_hash
    {
      title: title,
      description: [
        url,
        ((comment_url?) ? "Comments:\n#{comment_url}" : ''),
        "via #{source.humanize.capitalize}",
        "Saved: #{Time.zone.now} - Posted: #{created_at}"
      ].join("\n\n")
    }
  end

  def self.matching(session, sources = %w(hacker_news reddit product_hunt))
    items = where(source: sources).order(created_at: 'DESC')
    completed_to = session.completed_to || 1.month.ago
    unread = items.where(created_at: completed_to..Time.now)
               .order(created_at: 'DESC')
    read = items.where(created_at: 1.month.ago..completed_to)
             .order(created_at: 'DESC').limit(150)

    { unread: collection_to_hash(unread), read: collection_to_hash(read) }
  end

  def self.default
    all.order(created_at: 'DESC').limit(300)
  end

  def self.average_hour_count(sources)
    where(source: sources)
      .where('created_at >= ?', Time.zone.now - 1.days)
      .size / 24
  end

  def self.collection_to_hash(items)
    items.map do |item|
      item.attributes.merge(age: item.age)
    end
  end
end
