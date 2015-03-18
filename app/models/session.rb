class Session < ActiveRecord::Base
  serialize :sources, Array
  validates_uniqueness_of :identifier
  before_save do
    self.identifier = RandomUsername.username if self.identifier.blank?
  end

  def update_sources(source)
    sources.include?(source)? sources.delete(source) : sources << source
    save
  end

  def self.find_or_create(identifier)
    find_by_identifier(identifier) || create(identifier: identifier)
  end
end
