class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @items = Item.matching
  end

  def all
    @items = Item.all.order(created_at: 'DESC')
    render :index
  end

  def custom
    sources = cookies.permanent[:sources].split(',')
    if (SOURCES - sources) == SOURCES
      cookies.permanent[:sources] = ''
      return redirect_to :root
    end
    @items = Item.matching(sources)
    render :index
  end

  def add_source
    cookies.permanent[:sources] = '' if cookies.permanent[:sources].nil?
    cookie_list = cookies.permanent[:sources].split(',')
    if cookie_list.include?(params[:source])
      cookie_list.reject! { |s| s == params[:source] }
    else
      cookie_list << params[:source] if params[:source]
    end
    cookies.permanent[:sources] = cookie_list.join(',')
    return redirect_to custom_path
  end
end
