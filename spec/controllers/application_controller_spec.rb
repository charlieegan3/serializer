require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
  describe 'GET #index' do
    it 'should redirect to welcome for new users' do
      get :index
      should redirect_to welcome_path
    end

    it 'should assign items' do
      request.cookies[:welcomed] = true
      get :index
      should render_template :index
      expect(assigns(:items)).to_not be_nil
    end

    it 'should create a new session' do
      expect {
        request.cookies[:welcomed] = true
        get :index
      }.to change { Session.count }.by(1)
    end

    it 'should use an old session' do
      request.cookies[:session] = create(:session).identifier
      expect {
        get :index
      }.to_not change { Session.count }
    end

    it 'should return a json item list' do
      item_json = [create(:item)].to_json
      get :index, format: 'json'
      expect(response.body).to eq(item_json)
    end
  end
end
