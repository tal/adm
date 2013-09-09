class ADM::AccessToken
  attr_reader :client_id, :client_secret
  attr_reader :token

  def initialize opts
    @token      = opts['access_token']
    @expires_at = Time.now+opts['expires_in'].to_i
    @type       = opts['token_type']
    @scope      = opts['scope']
  end

  def to_s
    token
  end

  def valid?
    @expires_at < Time.now
  end

  def self.fetch client_id=nil, client_secret=nil
    client_id ||= ADM.client_id
    client_secret ||= ADM.client_secret
    data = request_data client_id, client_secret

    if data['error']
      raise TokenGetError, response.body
    end

    new(data)
  end

  def self.request_data client_id, client_secret
    request = Typhoeus::Request.new(
      'http://api.amazon.com/auth/O2/token',
      method: :post,
      body: {
        grant_type: :'client_credentials',
        scope: :'messaging:push',
        client_id: client_id,
        client_secret: client_secret
      },
      headers: {
        :Accept => :'application/json'
      }
    )
    response = request.run

    MultiJson.load(response.body)
  end

  def self.get_token
    if @token && @token.valid?
      return @token.token
    end

    @token = fetch

    @token.token
  end

  class TokenGetError < StandardError; end
end
