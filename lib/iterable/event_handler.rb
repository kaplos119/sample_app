module Iterable
  class EventHandler < Base

    # This method create events for event A, B and invokes mail trigger
    def create_event
      response = send_request
      json_response = JSON.parse(response.body)
      EmailHandler.new(user).deliver if email_flag && json_response['code'] == 'Success'
      return json_response['msg'], json_response['code']
    rescue StandardError => error
      Rails.logger.error "Not able to create event ==> #{error}"
      raise RequestError.new(I18n.t('lib.iterable.event_handler.backend_error'))
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
