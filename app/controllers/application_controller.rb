class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Notifier

  def index
    return not_found if request.env['HTTP_REFERER'] && request.env['HTTP_REFERER'].include?('simple-share-buttons.com')
    return redirect_to welcome_path unless cookies.permanent[:welcomed]

    if params[:session]
      flash[:message] = 'Session synced!</a>' unless flash[:message]
      @session = get_session(params[:session])
    else
      @session = get_session
    end

    @items = Item.matching
    return render json: @items if params[:format] == 'json'
    render :index
  end

  def welcome
    cookies.permanent[:welcomed] = true
    @session = get_session
  end

  def feedback
    unless params[:feedback].blank?
      send_feedback(params[:feedback][:comment], request.env['HTTP_USER_AGENT'])
      flash[:message] = 'Feedback Sent!'
      return redirect_to root_path
    end
  end

  def all
    @items = Item.all.order(created_at: 'DESC').limit(300)
    return render json: @items if params[:format] == 'json'
    @session = get_session
    render :index
  end

  def custom
    @session = get_session
    @items = Item.matching(@session.sources)
    render :index
  end

  def get_session(param = cookies.permanent[:session] || params[:session])
    Session.find_or_create(param).tap do |session|
      cookies.permanent[:session] = session.identifier
    end
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
