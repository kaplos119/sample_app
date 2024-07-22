require 'rails_helper'

RSpec.describe Iterable::EventHandler do
  let!(:event_a) { create(:event, event_name: 'event_a') }
  let!(:event_b) { create(:event, event_name: 'event_b') }
  let(:user) { create(:user, email: 'kk@gmail.com', password: 'abcdefghi') }
  let(:iterable_api_response) do
    {
      "msg": "Event created successfully",
      "code": "Success",
      "params": {}
    }
  end

  before do
    stub_request(:post, "#{ENV['ITERABLE_API_URL']}api/events/track").
      to_return(status: 201, body: iterable_api_response.to_json)
  end

  subject { described_class.new(user, event_name) }

  context 'when pass unknown event' do
    let(:event_name) { 'event_c' }
    it 'return error' do
      expect{ subject }.to raise_error(Iterable::UnknownEventException)
    end
  end

  context 'when pass event a' do
    let(:event_name) { 'event_a' }
    it 'create event in iterable for event a' do
      response = subject.create_event
      expect(Delayed::Job.count).to eql(0) # To check it won't trigger email notification for event a via delayed job
      expect(response[0]).to eql('Event created successfully')
      expect(response[1]).to eql('Success')
    end
  end

  context 'when pass event b' do
    let(:event_name) { 'event_b' }
    it 'create event in iterable for event b' do
      response = subject.create_event
      expect(Delayed::Job.count).to eql(1) # Ensure it will try to trigger email notification for event b via delayed job
      expect(response[0]).to eql('Event created successfully')
      expect(response[1]).to eql('Success')
    end
  end
end