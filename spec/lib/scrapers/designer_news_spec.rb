require 'rails_helper'

RSpec.describe DesignerNews do
  before(:all) do
    @dns = DesignerNews::DesignerNewsScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(DesignerNews::DesignerNewsScraper)
      .to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('designer_news') do
      items = @dns.items
      expect(items).to_not be_nil
      keys = [
        :comment_url, :redirect_url, :source, :title, :topped, :url, :word_count
      ]
      expect(items.sample.keys.sort).to eq(keys)
    end
  end

  it 'should reject duplicate items' do
    create(:item, redirect_url: 'http://serializer.io/')
    new_item = { title: 'serializer', redirect_url: 'http://serializer.io/' }
    expect(@dns.send(:reject_item?, new_item)).to be true
  end
end
