require 'rails_helper'

RSpec.describe SlashdotScraper do
  before(:all) do
    @ss = SlashdotScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(SlashdotScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('slashdot') do
      items = @ss.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
    end
  end
end
