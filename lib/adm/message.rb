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

    tokens.each do |token|
      ADM::Notification.new(token,self).queue(hydra)
    end

    hydra.run
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
