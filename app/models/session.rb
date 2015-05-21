class Session < ActiveRecord::Base
  serialize :sources, Array
  serialize :saved_items, Array
  validates_uniqueness_of :identifier
  validates_presence_of :identifier

  def update_sources(source)
    sources.include?(source)? sources.delete(source) : sources << source
    save
  end

  def self.find_or_create(identifier)
    if identifier.blank?
      create(identifier: self.generate_identifier)
    else
      find_by_identifier(identifier) || create(identifier: self.generate_identifier)
    end
  end

  def self.generate_identifier
    RandomUsername.username.tap do |identifier|
      10.times do
        break unless Session.find_by_identifier(identifier)
        identifier = RandomUsername.username
      end
    end
  end
end
