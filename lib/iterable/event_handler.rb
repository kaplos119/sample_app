module Iterable
  class EventHandler < Base

    def create_event
      response = send_request
      json_response = JSON.parse(response.body)
      EmailHandler.new(user).deliver if email_flag && json_response['code'] == 'Success'
      return json_response['msg'], json_response['code']
    rescue StandardError => error
      Rails.logger.error "Not able to create event ==> #{error}"
      raise RequestError.new('Backend Error')
    end

    private

    def url
      EVENT_API_URL
    end

    def payload
      {
        'email': user.email,
        'eventName': event.event_name,
        'id': event.id,
        'dataFields': {
          'source': 'CoffeeBeans App',
        },
        # "userId": "1", Since email is passed and as per api document only one of them should be passed
        'campaignId': 123,
        'templateId': 123,
        'createNewFields': true
      }
    end
  end
end
