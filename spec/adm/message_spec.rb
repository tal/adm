require 'spec_helper'

describe ADM::Message do
  let(:data)          { {"data" => {"title" => "Hello"}} }
  let(:message)       { ADM::Message.new(data) }
  let(:device_token)  { "ABC123" }
  let(:notification)  { double("notification") }

  describe "#send_to" do
    before do
      notification.stub(queue: true)
    end

    it "creates notification" do
      ADM::Notification
        .should_receive(:new)
        .with(device_token, message)
        .and_return(notification)
      message.send_to(device_token)
    end

    it "puts request from created notification to hydra queue and returns notifications" do
      ADM::Notification.stub(new: notification)
      notification.should_receive(:queue).with(message.hydra)
      notifications = message.send_to(device_token)
      expect(notifications).to be_kind_of(Array)
      expect(notifications).to_not be_empty
    end
  end
end
