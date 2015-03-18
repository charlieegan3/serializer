class SessionsController < ApplicationController
  def clear_session
    cookies.permanent[:session] = nil
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
    redirect_to root_path + session.identifier
  end
end
