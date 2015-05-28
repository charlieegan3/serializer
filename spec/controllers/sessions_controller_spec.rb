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
    it 'should redirect_to referrer' do
      request.cookies[:session] = create(:session).identifier
      request.env["HTTP_REFERER"] = root_path
      expect(get :log, time: Time.now).to redirect_to(root_path)
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
