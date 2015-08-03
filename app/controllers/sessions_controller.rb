class SessionsController < ApplicationController
  def show
    session = get_session
    render json: {
      session: session.attributes.merge(
        completed_to_human: session.completed_to_human,
      ),
      items: Item.matching(session)
    }
  end

  def sync
    if Session.valid_session_parameter(params[:session])
      message = '<strong>Session Synced!</strong>'
      flash[:message] = message.html_safe
      cookies.permanent[:welcomed] = true
      @session = get_session(params[:session])
    else
      @session = get_session
    end
    redirect_to root_path
  end

  def log
    session = get_session
    session.log(params[:time]) if params[:time]
    render json: {
      session: session.attributes.merge(
        completed_to_human: session.completed_to_human,
      ),
      items: Item.matching(session)
    }
  end

  def add_source
    session = get_session
    session.update_sources(JSON.parse(request.body.read)['source'])
    render json: session
  end

  def add_trello_story
    item = Item.find(params[:id])
    session = get_session
    session.add_trello_item(item)
    render text: 'saved'
  end

  def trello
    if params[:token] && params[:token].length == 64
      get_session.update_attribute(:trello_token, params[:token])
      tc = TrelloClient.new(params[:token])
      get_session.update_attribute(:trello_username, tc.fetch_username)
      tc.add_item(title: 'Welcome to serializer on Trello!')
    elsif params[:token]
      flash[:message] = 'Please check that token.'
    end
    @session = get_session
  end
end
