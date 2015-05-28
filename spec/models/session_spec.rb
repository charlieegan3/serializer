require 'rails_helper'

RSpec.describe Session, :type => :model do
  it { should validate_uniqueness_of(:identifier) }
  it { should serialize(:sources) }

  it 'should maintain a list of sources' do
    session = create(:session, sources: ['hacker_news'])
    session.update_sources('hacker_news')
    expect(session.sources).to eq([])
    session.update_sources('designer_news')
    expect(session.sources).to eq(['designer_news'])
  end

  it 'should find an existing session' do
    session = create(:session, identifier: 'charlie')
    found_session = Session.find_or_create('charlie')
    expect(found_session).to eq(session)
  end

  it 'should recreate a session a match it not found' do
    session = Session.find_or_create('missing')
    expect(session.identifier).to eq('missing')
  end

  describe 'valid_session_parameter' do
    it 'should accept a valid parameter' do
      expect(Session.valid_session_parameter('adjnoun')).to eq(true)
    end

    it 'should reject blanks' do
      expect(Session.valid_session_parameter('')).to eq(false)
    end

    it 'should reject if too long' do
      expect(Session.valid_session_parameter('a' * 101)).to eq(false)
    end

    it 'should reject if contains non lowercase letters' do
      expect(Session.valid_session_parameter('abcABC123')).to eq(false)
    end
  end
end
