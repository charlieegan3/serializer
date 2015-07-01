class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @items = Item.matching
    return render json: @items if params[:format] == 'json'
    return render xml: @items if params[:format] == 'xml'

    if Session.valid_session_parameter(params[:session])
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
    if request.env['HTTP_REFERER']
      return redirect_to :back
    else
      return redirect_to root_path
    end
  end

  def get_session(param = cookies.permanent[:session] || params[:session])
    Session.find_or_create(param).tap do |session|
      cookies.permanent[:session] = session.identifier
    end
  end
end
