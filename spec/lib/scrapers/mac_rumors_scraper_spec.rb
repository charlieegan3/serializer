require 'rails_helper'

RSpec.describe MacRumorsScraper do
  before(:all) do
    @mrs = MacRumorsScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(MacRumorsScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('macrumors') do
      items = @mrs.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject duplicate items' do
    create(:item, url: 'http://www.serializer.io/')
    new_item = { url: 'http://www.serializer.io/' }
    expect(@mrs.send(:reject_item?, new_item)).to be true
  end
end
