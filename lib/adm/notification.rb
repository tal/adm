class ADM::Notification
  attr_reader :registration_id, :message

  def initialize registration_id, message
    if message.is_a?(ADM::Message)
      @message = message
    else
      @message = ADM::Message.new(message)
    end

    @registration_id = registration_id
  end

  def token
    ADM::AccessToken.get_token
  end

  def request
    @request ||= Typhoeus::Request.new(
      "https://api.amazon.com/messaging/registrations/#{registration_id}/messages",
      method: :post,
      body: message.compile,
      headers: {
        :Accept                 => :'application/json',
        :'Content-Type'         => :'application/json',
        :'X-Amzn-Type-Version'  => :'com.amazon.device.messaging.ADMMessage@1.0',
        :'X-Amzn-Accept-Type'   => :'com.amazon.device.messaging.ADMSendResult@1.0',
        :Authorization          => "Bearer #{token}"
      }
    )
  end

  def send
    request.run
  end

  def queue hydra
    hydra.queue(self.request)
  end
end
