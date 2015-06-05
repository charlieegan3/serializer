require 'rails_helper'

RSpec.describe Lobsters do
  before(:all) do
    @ls = Lobsters::LobstersScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(Lobsters::LobstersScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('lobsters') do
      items = @ls.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject items with an invalid title' do
    expect(@ls.send(:reject_item?, title: 'working on this week'))
      .to be true
  end

  it 'should reject items with an invalid title' do
    expect(@ls.send(:reject_item?, title: 'working on this week'))
      .to be true
  end

  it 'should reject duplicate items' do
    create(:item, url: 'http://serializer.io/')
    new_item = { title: 'serializer', url: 'http://serializer.io/' }
    expect(@ls.send(:reject_item?, new_item)).to be true
  end
end
