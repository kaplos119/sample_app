module Iterable
  class EmailHandler < Base
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def deliver
      send_request
    end

    handle_asynchronously :deliver

    private

    def url
      EMAIL_API_URL
    end

    def payload
      {
        'campaignId': 123,
        'recipientEmail': user.email,
        'dataFields': {
          'customParam': 'paramValue'
        },
        'sendAt': "#{Time.now}"
      }
    end
  end
end