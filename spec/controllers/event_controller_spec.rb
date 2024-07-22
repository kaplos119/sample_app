require 'rails_helper'

RSpec.describe EventController do
  let!(:event_a) { create(:event, event_name: 'event_a') }
  let!(:event_b) { create(:event, event_name: 'event_b') }
  let(:user) { create(:user, email: 'kk@gmail.com', password: 'abcdefghi') }
  let(:request_payload_a) { { 'event_name': 'event_a' } }
  let(:request_payload_b) { { 'event_name': 'event_b' } }
  let(:unknown_request_event) { { 'event_name': 'event_c' } }
  let(:iterable_api_response) do
    {
      "msg": "Event created successfully",
      "code": "Success",
      "params": {}
    }
  end

  describe "POST create" do

    context 'when user is not logged in then it should' do
      it 'return 401 error' do
        post :create
        expect(response.status).to eql(401)
        expect(response.body).to eql(I18n.t('controllers.event.unauthorized_user'))
      end
    end

    context 'when use is logged in' do
      before do
        allow(controller).to receive(:current_user).and_return(user)
        stub_request(:post, "#{ENV['ITERABLE_API_URL']}api/events/track").
          to_return(status: 201, body: iterable_api_response.to_json)
      end

      it 'pass unknown event and return bad request status' do
        post :create, params: unknown_request_event
        expect(response.body).to eql(I18n.t('lib.iterable.base.unknown_event'))
        expect(response.status).to eql(400)
      end

      it 'pass event a' do
        post :create, params: request_payload_a
        expect(Delayed::Job.count).to eql(0) # To check it won't trigger email notification for event a via delayed job
        expect(response.body).to eql('Event created successfully')
        expect(response.status).to eql(200)
      end

      it 'pass event b' do
        post :create, params: request_payload_b
        expect(Delayed::Job.count).to eql(1) # Ensure it will try to trigger email notification for event b via delayed job
        expect(response.body).to eql('Event created successfully')
        expect(response.status).to eql(200)
      end
    end
  end
end