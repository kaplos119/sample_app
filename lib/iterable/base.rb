module Iterable
  class Base
    attr_reader :user, :event, :email_flag

    EVENT_API_URL = "#{ENV.fetch('ITERABLE_API_URL')}api/events/track".freeze
    EMAIL_API_URL = "#{ENV.fetch('ITERABLE_API_URL')}api/email/target".freeze
    API_KEY = ENV.fetch('API_KEY').freeze

    def initialize(user, event_name)
      @user = user
      @event = Event.find_by(event_name: event_name)
      raise UnknownEventException.new('Unknown event name passed') if event.nil?
      @email_flag = event_name == 'event_b' ? true : false
    end

    def send_request
      RestClient.post(url, payload.to_json, headers)
    end

    private

    def headers
      {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Api-Key': API_KEY
      }
    end
  end

  class UnknownEventException < StandardError
    attr_reader :error_message

    def initialize(error)
      @error_message = error
    end
  end

  class RequestError < StandardError
    attr_reader :error_message

    def initialize(error)
      @error_message = error
    end
  end
end
