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
end
