require 'rails_helper'

RSpec.describe ProductHunt do
  before(:all) do
    @phs = ProductHunt::ProductHuntScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(ProductHunt::ProductHuntScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('product_hunt') do
      items = @phs.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped, :redirect_url]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject items on the redirect_url' do
    redirect_url = 'http://serializer.io'
    create(:item, redirect_url: redirect_url)
    expect(@phs.send(:reject_item?, { redirect_url: redirect_url })).to be true
  end
end
