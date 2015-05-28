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

  describe 'log' do
    it 'should update to a past time value' do
      session, time = create(:session), 1.minutes.ago
      session.log(time)
      expect(session.completed_to).to eq(time)
    end

    it 'should limit to a past value' do
      session, time = create(:session), Time.now + 1.minutes
      session.log(time)
      expect(session.completed_to).to be < Time.now
    end
  end

  describe 'find_or_create' do
    it 'should recreate a session a match it not found' do
      session = Session.find_or_create('missing')
      expect(session.identifier).to eq('missing')
    end

    it 'should create a new session if identifier is nil' do
      session = Session.find_or_create(nil)
      expect(session).to_not be_nil
      expect(session.identifier).to match(/[a-z]+/)
    end
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

    it 'should return false for a nil parameter' do
      expect(Session.valid_session_parameter(nil)).to eq(false)
    end
  end

  describe 'generate_identifier' do
    it 'should return a unique identifier' do
      expect(Session.generate_identifier).to match(/[a-z]+/)
    end
  end
end
