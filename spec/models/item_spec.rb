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

  it 'returns a limited all list as default' do
    301.times do
      create(:item, source: SOURCES.sample)
    end
    expect(Item.default.size).to eq(300)
  end

  it 'returns the days hour count' do
    24.times do
      create(:item, created_at: Time.zone.now - 1.days)
      create(:item, created_at: Time.zone.now)
    end
    expect(Item.average_hour_count(SOURCES)).to eq(1)
  end

  it 'should not save items if the story has already been covered' do
    create(:item, title: 'the news story')
    duplicate = build(:item, title: 'The News Story')
    expect { duplicate.save! }.to raise_error(ActiveRecord::RecordNotSaved)
  end

  it 'should still save items if the story resurfaces' do
    create(:item, title: 'the news story', created_at: Time.zone.now - 3.days)
    duplicate = build(:item, title: 'the news story')
    expect { duplicate.save! }.not_to raise_error
  end

  it 'should save items if they are sufficiently different' do
    create(:item, title: 'the news story')
    duplicate = build(:item, title: 'Another News Story')
    expect { duplicate.save! }.not_to raise_error
  end
end
