require 'rails_helper'

RSpec.describe HackerNewsScraper do
  before(:all) do
    @hns = HackerNewsScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(HackerNewsScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('hacker_news') do
      items = @hns.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
      expect(items.select { |i| i[:topped] }.size).to eq(2)
    end
  end

  describe 'reject_item?' do
    it 'should reject duplicate items' do
      create(:item, url: 'http://www.serializer.io/')
      new_item = { title: 'serializer', url: 'http://www.serializer.io/' }
      expect(@hns.send(:reject_item?, new_item)).to be true
    end

    it 'should reject hiring posts' do
      new_item = { title: 'People do not care that serializer hiring' }
      expect(@hns.send(:reject_item?, new_item)).to be true
    end
  end

  describe 'relative_url' do
    it 'should detect a relative_url' do
      expect(@hns.send(:relative_url?, '/thing')).to be true
    end

    it 'should not detect an absolute url' do
      expect(@hns.send(:relative_url?, 'http://www.google.com')).to be false
    end
  end
end
