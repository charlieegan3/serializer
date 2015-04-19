module Notifier
  def send_errors(errors)
    Gmail.connect(GMAIL_ACCOUNT, GMAIL_PASSWORD) do |gmail|
      gmail.deliver do
        to NOTIFY_EMAIL
        subject 'Error Notifier'
        text_part do
          body errors.join("\n\n")
        end
      end
    end
  end

  def send_feedback(comment, user_agent)
    Gmail.connect(GMAIL_ACCOUNT, GMAIL_PASSWORD) do |gmail|
      gmail.deliver do
        to NOTIFY_EMAIL
        subject 'Feedback Notifier'
        text_part do
          body "#{comment}\n\n#{user_agent}"
        end
      end
    end
  end
end
