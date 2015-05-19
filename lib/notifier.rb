module Notifier
  def send_errors(errors)
    Gmail.connect(ENV['GMAIL_ACCOUNT'], ENV['GMAIL_PASSWORD']) do |gmail|
      gmail.deliver do
        to ENV['NOTIFY_EMAIL']
        subject 'Error Notifier'
        text_part do
          body errors.join("\n\n")
        end
      end
    end
  end
end
