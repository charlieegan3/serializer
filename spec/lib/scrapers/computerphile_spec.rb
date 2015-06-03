require 'rails_helper'

RSpec.describe Computerphile do
  before(:all) do
    @cs = Computerphile::ComputerphileScraper.new
  end

  it 'should return items' do
    VCR.use_cassette('computerphile') do
      items = @cs.items
      expect(items).to_not be_nil
      keys = [:title, :url, :word_count, :comment_url, :source, :topped]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should calculate minute_duration' do
    expect(@cs.send(:minute_duration, 'Duration: 10 minutes.')).to eq(3000)
    expect(@cs.send(:minute_duration, '')).to eq(0)
    expect(@cs.send(:minute_duration, 'abcABC')).to eq(0)
  end
end
