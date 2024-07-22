module Iterable
  class Base
    attr_reader :user, :event, :email_flag

    EVENT_API_URL = "#{ENV.fetch('ITERABLE_API_URL')}api/events/track".freeze
    EMAIL_API_URL = "#{ENV.fetch('ITERABLE_API_URL')}api/email/target".freeze
    API_KEY = ENV.fetch('API_KEY').freeze

    def initialize(user, event_name)
      @user = user
      @event = Event.find_by(event_name: event_name)
      raise UnknownEventException.new(I18n.t('lib.iterable.base.unknown_event')) if event.nil? # Stop the flow if unknown event passed to backend which is not supported
      @email_flag = event_name == 'event_b' ? true : false # email flag true if it is Event B
    end

    # This method is responsible to invoke iterable api's
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

  # Initiates exception object for unknown event
  class UnknownEventException < StandardError
    attr_reader :error_message

    def initialize(error)
      @error_message = error
    end
  end

  # Initiates request error when occured from iterable
  class RequestError < StandardError
    attr_reader :error_message

    def initialize(error)
      @error_message = error
    end
  end
end
