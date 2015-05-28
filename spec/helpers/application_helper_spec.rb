require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do
  describe 'time_ago' do
    it 'removes "about"' do
      expect(helper.time_ago((1.5).hours.ago)).to_not include('about')
    end

    it 'removes "less than"' do
      expect(helper.time_ago(10.seconds.ago)).to_not include('less than')
    end

    it 'shortens to "h"' do
      expect(helper.time_ago(3.hours.ago)).to include('h')
    end

    it 'shortens to "m"' do
      expect(helper.time_ago(3.minutes.ago)).to include('m')
    end
  end

  describe 'unread_count' do
    it 'counts all as unread with a session' do
      items = [build(:item), build(:item)]
      result = helper.unread_count(items, build(:session, completed_to: nil))
      expect(result).to include('2')
    end

    it 'counts unread items based on the sessions completed_to' do
      items = [build(:item, created_at: 10.days.ago), build(:item)]
      session = build(:session, completed_to: 1.hour.ago)
      result = helper.unread_count(items, session)
      expect(result).to include('1')
    end
  end

  describe 'print_url' do
    it 'removes params' do
      url = 'http://www.google.com?some=junk-on-the-end'
      expect(helper.print_url(url)).to eq('google.com')
    end

    it 'removes www' do
      url = 'http://www.google.com'
      expect(helper.print_url(url)).to eq('google.com')
    end

    it 'cuts truncates to the limit' do
      url = 'http://www.google.com'
      expect(helper.print_url(url, 5)).to eq('google...')
    end
  end
end
