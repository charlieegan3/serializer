module ApplicationHelper
  def unread_count(items, session)
    if session.completed_to
      unread = items.reject { |x| x.created_at < session.completed_to }.size
    else
      unread = items.size
    end
    (unread > 0) ? "#{unread} new - serializer" : nil
  end
end
