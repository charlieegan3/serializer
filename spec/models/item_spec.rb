require 'rails_helper'

RSpec.describe Item, :type => :model do
  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:title) }

  it 'should truncate titles longer than 140chrs' do
    item = create(:item, title: 'news ' * 100)
    expect(item.title.length).to eq(144)
  end

  it 'returns matching items' do
    for i in 0...SOURCES.size
      create(:item, source: SOURCES[i])
    end
    expect(Item.matching.size).to eq(3)
    expect(Item.matching(SOURCES).size).to eq(SOURCES.size)
  end

  it 'returns the days hour count' do
    24.times do
      create(:item, created_at: Time.zone.now - 1.days)
      create(:item, created_at: Time.zone.now)
    end
    expect(Item.average_hour_count(SOURCES)).to eq(1)
  end
end
