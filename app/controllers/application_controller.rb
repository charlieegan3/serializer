class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def index
     render json: Item.default if params[:format] == 'json'
    @session = get_session
  end

  def get_session(param = cookies[:session] || params[:session] || request.cookies['session'])
    Session.find_or_create(param).tap do |session|
      cookies.permanent[:session] = session.identifier
    end
  end
end
