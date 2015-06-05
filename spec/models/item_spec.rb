require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:title) }

  it 'should truncate titles longer than 140chrs' do
    item = create(:item, title: 'news ' * 100)
    expect(item.title.length).to eq(144)
  end

  it 'returns matching items' do
    SOURCES.each do |s|
      create(:item, source: s)
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

  it 'should remove content types from titles' do
    item = create(:item, title: 'title [pdf]')
    expect(item.title).to eq('title')
  end

  it 'should remove utm params from urls' do
    item = create(:item, url: 'https://www.site.com/path?utm_source=src&utm_campaign=cam&utm_medium=med&utm_term=ter&saved=1')
    expect(item.url).to eq('https://www.site.com/path?saved=1')
  end

  it 'should remove ref= params from urls' do
    item = create(:item, url: 'http://site.com/?ref=referrer')
    expect(item.url).to eq('http://site.com/')
  end

  it 'should not save items if the story has already been covered' do
    create(:item, title: 'the news story')
    duplicate = build(:item, title: 'The News Story')
    expect { duplicate.save! }.to raise_error('ItemTooSimilar')
  end

  it 'should ignore url protocol' do
    create(:item, url: 'https://www.site.com/')
    expect { create(:item, url: 'http://www.site.com/') }
      .to raise_error('ItemTooSimilar')
  end

  it 'should ignore surplus non word characters' do
    create(:item, url: 'https://with-trailing.slash/')
    expect { create(:item, url: 'http://with-trailing.slash') }
      .to raise_error('ItemTooSimilar')
  end

  it 'should count bare domain as equal' do
    create(:item, url: 'https://site.com')
    expect { create(:item, url: 'http://www.site.com') }
      .to raise_error('ItemTooSimilar')
  end

  it 'should correctly calculate reading_time' do
    item = build(:item, word_count: 300)
    expect(item.reading_time).to be(1)
  end

  it 'should return a format for pdf urls' do
    item = build(:item, url: 'http://site.com/x.pdf')
    expect(item.format).to eq('pdf')
  end

  it 'should return a format for pdf urls' do
    item = build(:item, url: 'http://site.com/x.pdf')
    expect(item.format).to eq('pdf')
  end

  it 'should return a format for image urls' do
    format = %w(jpg png gif).sample
    item = build(:item, url: "http://site.com/x.#{format}")
    expect(item.format).to eq('img')
  end

  it 'should assign a "watch" reading kind for videos' do
    expect(build(:item, url: 'http://youtube.com').reading_kind).to eq('watch')
  end

  it 'should return a sorted list as "default"' do
    item_a, item_b, item_c = [
      create(:item, created_at: 1.hours.ago),
      create(:item, created_at: 3.hours.ago),
      create(:item, created_at: 2.hours.ago)
    ]
    expect(Item.default).to eq([item_a, item_c, item_b])
  end

  it 'should build a trello item' do
    item = build(:item,
                 title: '123abc',
                 url: 'http://www.abc.com/',
                 source: '123')
    expect(item.trello_hash[:title]).to eq(item.title)
    expect(item.trello_hash[:description]).to include(item.url)
    expect(item.trello_hash[:description]).to include(item.created_at.to_s)
  end
end
