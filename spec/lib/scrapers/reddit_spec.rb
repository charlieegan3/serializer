require 'rails_helper'

RSpec.describe Reddit do
  before(:all) do
    @rs = Reddit::RedditScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(Reddit::RedditScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('reddit') do
      items = Reddit.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  describe 'reject_item?' do
    it 'should reject duplicate items' do
      create(:item, url: 'http://www.serializer.io/')
      new_item = { title: 'serializer', url: 'http://www.serializer.io/' }
      expect(@rs.send(:reject_item?, new_item)).to be true
    end

    it 'should reject relative links' do
      new_item = { url: '/thing' }
      expect(@rs.send(:reject_item?, new_item)).to be true
    end
  end
end
