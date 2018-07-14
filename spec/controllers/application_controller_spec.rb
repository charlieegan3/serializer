require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'GET #index' do
    it 'should create a new session' do
      request.cookies[:welcomed] = true
      expect { get :index }.to change { Session.count }.by(1)
    end

    it 'should use an old session' do
      request.cookies[:session] = create(:session).identifier
      expect { get :index }.to_not change { Session.count }
    end

    it 'should retrieve a session' do
      create(:session, identifier: 'some_session')
      expect { get :index, params: { session: 'some_session' } }
        .to_not change { Session.count }
    end

    it 'should return a json item list' do
      item_json = [create(:item)].to_json
      get :index, format: 'json'
      expect(response.body).to eq(item_json)
    end

    it 'should sync the session when given a valid parameter' do
      get :index, params: { session: 'adjnoun' }
      expect(assigns(:session).identifier).to eq('adjnoun')
    end
  end
end
