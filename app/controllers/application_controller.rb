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
    sources = cookies.permanent[:sources] || ''
    sources = cookies.permanent[:sources].split(',')
    if (SOURCES - sources) == SOURCES
      cookies.permanent[:sources] = ''
    end
    @items = Item.matching(sources)
    render :index
  end

  def set_bookmark
    cookies.permanent[:bookmark] = Time.new
    return redirect_to :back
  end

  def add_source
    cookies.permanent[:sources] = '' if cookies.permanent[:sources].nil?
    sources = cookies.permanent[:sources].split(',')
    if sources.include?(params[:source])
      sources.reject! { |s| s == params[:source] }
    else
      sources << params[:source] if params[:source]
    end
    cookies.permanent[:sources] = sources.join(',')
    return redirect_to custom_path
  end
end
