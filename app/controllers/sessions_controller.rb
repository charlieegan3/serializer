class SessionsController < ApplicationController
  def clear_session
    cookies.permanent[:session] = nil
    session = get_session
    flash[:message] = "Sync your new session with <a href=\"#{root_path + session.identifier}\">this link</a>"
    redirect_to root_path
  end

  def log
    session = get_session
    session.update_attribute(:completed_to, params[:time])
    return redirect_to :back
  end

  def add_source
    return redirect_to :back unless SOURCES.include?(params[:source])
    get_session.update_sources(params[:source])
    return redirect_to :back
  end

  def share
    session = get_session
    path = root_path + session.identifier
    flash[:message] = "Visit <a href=\"#{path}\">this link</a> on your other devices to sync your read status and settings"
    redirect_to path
  end
end
