require 'rails_helper'
require 'json'

RSpec.describe SessionsController, type: :controller do
  describe 'GET #log' do
    it 'should return the session' do
      completed_to = Time.now
      get :log, time: completed_to
      expect(JSON.parse(response.body)['session'])
        .to_not be_nil
    end
  end

  describe 'GET #add_source' do
    it 'should render a json session' do
      get :add_source, { source: 'hacker_news' }.to_json
      expect(JSON.parse(response.body)['sources']).to eq ['hacker_news']
    end
  end
end
