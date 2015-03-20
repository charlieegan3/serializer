module Notifier
  def send_errors(errors)
    Gmail.connect('charlie.notifications', 'notifications') do |gmail|
      gmail.deliver do
        to 'accounts@charlieegan3.com'
        subject 'Error Notifier'
        text_part do
          body errors.join("\n\n")
        end
      end
    end
  end

  def send_feedback(comment, user_agent)
    Gmail.connect('charlie.notifications', 'notifications') do |gmail|
      gmail.deliver do
        to 'accounts@charlieegan3.com'
        subject 'Feedback Notifier'
        text_part do
          body "#{comment}\n\n#{user_agent}"
        end
      end
    end
  end
end
