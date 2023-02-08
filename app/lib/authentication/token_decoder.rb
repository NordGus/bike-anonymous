class Authentication::TokenDecoder
  SECRET = Rails.application.credentials.jwt_secret.freeze
  JWT_ALGORITHM = 'HS256'.freeze
  JWT_EXPIRATION = 5.minutes.freeze
  SESSION_EXPIRATION = 7.days.freeze

  attr_reader :payload, :headers

  def initialize(token)
    @token = token
    @payload = nil
    @headers = nil
  end

  def decode
    decoded = JWT.decode(@token, SECRET, true, { algorithm: JWT_ALGORITHM })

    @payload = decoded[0].symbolize_keys
    @headers = decoded[1].symbolize_keys

    true
  end
end