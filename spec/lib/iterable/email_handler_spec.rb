require 'rails_helper'

RSpec.describe Iterable::EmailHandler do
  let(:user) { create(:user, email: 'kk@gmail.com', password: 'abcdefghi') }
  let(:iterable_api_response) do
    {
      "msg": "Event created successfully",
      "code": "Success",
      "params": {}
    }
  end

  before do
    stub_request(:post, "#{ENV['ITERABLE_API_URL']}api/email/target").
      to_return(status: 201, body: iterable_api_response.to_json)
  end

  subject { described_class.new(user) }

  context 'when event b created' do
    it 'trigger email' do
      subject.deliver
      expect(Delayed::Job.count).to eql(1)
      successes, failures = Delayed::Worker.new.work_off
      expect(Delayed::Job.count).to eql(0)
      expect(successes).to eql(1)
      expect(failures).to eql(0)
    end
  end
end
