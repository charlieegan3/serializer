require 'rails_helper'

RSpec.describe Qudos do
  before(:all) do
    @qs = Qudos::QudosScraper.new
  end

  it 'should return items' do
    allow_any_instance_of(Qudos::QudosScraper).to receive(:word_count)
      .and_return(0)
    VCR.use_cassette('qudos') do
      items = @qs.items
      expect(items).to_not be_nil
      keys = [
        :title, :url, :word_count, :comment_url, :source, :topped, :redirect_url
      ]
      expect(items.sample.keys - keys).to be_empty
    end
  end

  it 'should reject duplicate items' do
    create(:item, redirect_url: 'http://serializer.io/')
    new_item = { title: 'serializer', redirect_url: 'http://serializer.io/' }
    expect(@qs.send(:reject_item?, new_item)).to be true
  end
end
