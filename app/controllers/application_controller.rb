class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    cookies.permanent[:session] = Session.find_by_identifier(params[:session]).identifier if params[:session]
    return redirect_to new_session_path if cookies.permanent[:session].blank?
    @items = Item.matching
    return render json: @items if params[:format] == 'json'
    return render :index
  end

  def all
    cookies.permanent[:session] = Session.find_by_identifier(params[:session]).identifier if params[:session]
    return redirect_to new_session_path if cookies.permanent[:session].blank?
    @items = Item.all.order(created_at: 'DESC').limit(300)
    return render json: @items if params[:format] == 'json'
    return render :index
  end

  def custom
    sources = Session.find_by_identifier(cookies.permanent[:session]).sources
    if (SOURCES - sources) == SOURCES
      cookies.permanent[:sources] = ''
    end
    @items = Item.matching(sources)
    render :index
  end
end
