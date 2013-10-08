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
      compiled_data = data.dup

      if compiled_data[:data]
        compiled_data[:data].each do |k,v|
          compiled_data[:data][k] = MultiJson.dump(compiled_data[:data][k])
        end
      elsif compiled_data['data']
        compiled_data['data'].each do |k,v|
          compiled_data['data'][k] = MultiJson.dump(compiled_data['data'][k])
        end
      end

      MultiJson.dump(compiled_data)
    end
  end
end
