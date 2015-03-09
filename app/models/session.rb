class Session < ActiveRecord::Base
  serialize :sources, Array
  validates_uniqueness_of :identifier
  before_save do
    self.identifier = RandomUsername.username unless self.identifier
  end

  def update_sources(source)
    sources.include?(source)? sources.delete(source) : sources << source
    save
  end
end
