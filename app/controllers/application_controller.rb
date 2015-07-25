class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @session = get_session
  end

  def about
    @session = get_session
  end

  def feedback
    @session = get_session
  end

  def get_session(param = cookies.permanent[:session] || params[:session])
    Session.find_or_create(param).tap do |session|
      cookies.permanent[:session] = session.identifier
    end
  end
end
