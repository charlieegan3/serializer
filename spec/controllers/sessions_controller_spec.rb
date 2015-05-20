require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  describe 'GET #clear' do
    it 'clear cookies' do
      get :clear_session
      expect(response.cookies['session']).to be_nil
      expect(response.cookies['welcomed']).to be_nil
      expect(response.cookies['link_target']).to be_nil
      expect(response.cookies.keys).to eq(['session', 'welcome', 'link_target'])
    end

    it 'clear redirect_to welcome' do
      get :clear_session
      should set_flash[:message].to('All cookies cleared.')
      should redirect_to welcome_path
    end
  end

  describe 'GET #log' do
    it 'should update completed_to' do
      pending 'fix'
      fail
      # session = create(:session)
      # request.env["HTTP_REFERER"] = root_path
      # request.cookies[:session] = session.identifier
      # p Session.count
      # expect {
      #   get :log, time: Time.now
      # }.to change { session.completed_to }
    end
  end

  describe 'GET #add_source' do
    before(:each) do
      request.env["HTTP_REFERER"] = root_path
    end

    it 'should redirect back if source is invalid' do
      get :add_source, source: 'invalid'
      should redirect_to root_path
    end

    it 'should add new sources' do
      pending 'fix'
      fail
      # session = create(:session, sources: [])
      # request.cookies[:session] = session.identifier
      # get :add_source, source: SOURCES.sample
      # expect(session.sources).to_not eq([])
    end

    it 'should remove sources' do
      pending 'fix'
      fail
      # session = create(:session, sources: ['hacker_news'])
      # request.cookies[:session] = session.identifier
      # get :add_source, source: 'hacker_news'
      # expect(session.sources).to_not eq([])
    end
  end

  describe 'GET #share' do
    it 'flash a share message' do
      session = create(:session)
      request.cookies[:session] = session.identifier
      get :share
      expect(flash[:message]).to include(session.identifier)
      expect(response.location).to include(session.identifier)
    end
  end
end
