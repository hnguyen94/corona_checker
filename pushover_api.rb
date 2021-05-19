require 'httparty'

class PushoverApi
  include HTTParty

  def self.send_push_notification(message:)
    self.post('https://api.pushover.net/1/messages.json', body: {
      'token'   => ENV['APP_TOKEN'],
      'user'    => ENV['USER_TOKEN'],
      'message' => message
    })
  end
end