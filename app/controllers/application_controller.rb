class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @session = get_session(params[:session] || cookies.permanent[:session])
    @items = Item.matching
    return render json: @items if params[:format] == 'json'
    render :index
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
end
