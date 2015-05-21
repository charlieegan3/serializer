class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Notifier

  def index
    return render json: Item.matching if params[:format] == 'json'

    if params[:session]
      message = '<strong>Session Synced!</strong> Now choose:
        <a href="/">default</a>, <a href="/all">all</a>
        or <a href="/custom">custom</a>'
      flash.now[:message] = message.html_safe unless flash[:message]
      cookies.permanent[:welcomed] = true
      @session = get_session(params[:session])
    else
      return redirect_to welcome_path unless cookies.permanent[:welcomed]
      @session = get_session
    end

    @items = Item.matching
    render :index
  end

  def welcome
    cookies.permanent[:welcomed] = true
    @session = get_session
  end

  def feedback
    @session = get_session
  end

  def all
    return render json: Item.default if params[:format] == 'json'
    return redirect_to welcome_path unless cookies.permanent[:welcomed]
    @items = Item.default
    @session = get_session
    render :index
  end

  def custom
    return redirect_to welcome_path unless cookies.permanent[:welcomed]
    @session = get_session
    @items = Item.matching(@session.sources)
    render :index
  end

  def set_link_behavior
    cookies.permanent[:link_target] = params[:choice].to_i
    redirect_to :back
  end

  def get_session(param = cookies.permanent[:session] || params[:session])
    Session.find_or_create(param).tap do |session|
      cookies.permanent[:session] = session.identifier
    end
  end
end
