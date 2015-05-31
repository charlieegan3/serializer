require 'rails_helper'

RSpec.describe BetaListScraper do
  before(:all) do
    @bls = BetaListScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(BetaListScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('beta_list') do
      items = @bls.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped, :redirect_url]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject duplicate items' do
    create(:item, redirect_url: 'http://www.serializer.io/')
    new_item = { title: 'serializer', redirect_url: 'http://www.serializer.io/' }
    expect(@bls.send(:reject_item?, new_item)).to be true
  end
end
