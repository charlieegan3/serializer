module Notifier
  def send(errors)
    Gmail.connect('charlie.notifications', 'notifications') do |gmail|
      gmail.deliver do
        to 'accounts@charlieegan3.com'
        subject "Hey"
        text_part do
          body errors.join("\n\n")
        end
      end
    end
  end
end
