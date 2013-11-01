require 'spec_helper'

describe ADM::Notification do
  let(:registration_id)   { "ABC123" }
  let(:message)           { {"data" => {"title" => "Hello"}} }
  let(:compiled_message)  { "{\"data\":{\"title\":\"\\\"Hello\\\"\"}}" }
  let(:token)             { "TOKEN" }
  let(:notification)      { ADM::Notification.new(registration_id, message) }

  before do
    notification.stub(token: token)
    notification.stub(compile: compiled_message)
  end

  describe "#request" do
    it "creates new request" do
      Typhoeus::Request.should_receive(:new)
      notification.request
    end
  end

  describe "#send" do
    let(:request) { double("request") }

    before do
      notification.stub(request: request)
    end

    it "creates new request" do
      request.should_receive(:run)
      notification.send
    end
  end

end
