class SessionsController < ApplicationController
  def clear_session
    cookies.permanent[:session] = nil
    cookies.permanent[:welcome] = nil
    cookies.permanent[:link_target] = nil
    flash[:message] = 'All cookies cleared.'
    redirect_to welcome_path
  end

  def log
    get_session.log(params[:time]) if params[:time]
    if request.env["HTTP_REFERER"]
      return redirect_to :back
    else
      return redirect_to root_path
    end
  end

  def add_source
    return redirect_to :back unless SOURCES.include?(params[:source])
    get_session.update_sources(params[:source])
    if request.env["HTTP_REFERER"]
      return redirect_to :back
    else
      return redirect_to root_path
    end
  end

  def share
    session = get_session
    path = root_path + session.identifier
    flash[:message] = "Visit <a href=\"#{path}\">this link</a> <strong>once</strong> on other devices to sync your read status"
    redirect_to path
  end

  def add_trello_story
    item = Item.find(params[:id])
    session = get_session
    session.add_trello_item(item)
    redirect_to location_path(request.referer, item)
  end

  def trello
    if params[:token] && params[:token].length == 64
      get_session.update_attribute(:trello_token, params[:token])
      tc = TrelloClient.new(params[:token])
      get_session.update_attribute(:trello_username, tc.fetch_username)
      tc.add_item({title: 'Welcome to serializer on Trello!'})
    elsif params[:token]
      flash[:message] = 'Please check that token.'
    end
    @session = get_session
  end

  private
    def location_path(referer, item)
      path = (referer) ? referer : all_path
      path = path[0..path.index('#')-1] if path.include?('#')
      "#{path}/##{item.id}".gsub(/\/+/, '/').gsub(/http:\//, 'http://')
    end
end
