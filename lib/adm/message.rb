class ADM::Message
  attr_reader :compiled,:data
  attr_writer :hydra

  def initialize data={}
    @data = data
  end

  def send_to *tokens
    if tokens.first.is_a?(Array)
      tokens = tokens.first
    end

    notifications = tokens.collect do |token|
      note = ADM::Notification.new(token,self)
      note.queue(hydra)
      note
    end

    hydra.run

    notifications
  end

  def hydra
    @hydra ||= Typhoeus::Hydra.hydra
  end

  def compile
    @json ||= begin
      @compiled = true

      MultiJson.dump(data)
    end
  end
end
