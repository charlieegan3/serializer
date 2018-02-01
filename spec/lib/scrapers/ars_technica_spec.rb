require 'rails_helper'

RSpec.describe ArsTechnica do
  before(:all) do
    @ats = ArsTechnica::ArsTechnicaScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(ArsTechnica::ArsTechnicaScraper)
      .to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('ars_technica') do
      items = @ats.items
      expect(items).to_not be_nil
      keys = [
        :title, :url, :word_count, :comment_url, :source, :topped, :redirect_url
      ]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject duplicate items' do
    create(:item, redirect_url: 'http://www.serializer.charlieegan3.com/')
    new_item = { redirect_url: 'http://www.serializer.charlieegan3.com/' }
    expect(@ats.send(:reject_item?, new_item)).to be true
  end
end
