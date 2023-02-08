class Authentication::TokenGenerator
  SECRET = Rails.application.credentials.jwt_secret.freeze
  JWT_ALGORITHM = 'HS256'.freeze
  JWT_EXPIRATION = 5.minutes.freeze
  SESSION_EXPIRATION = 7.days.freeze

  def initialize(user)
    @user = user
  end

  def authentication_token
    JWT.encode(
      payload.merge({ exp: JWT_EXPIRATION.from_now.to_i }),
      SECRET,
      JWT_ALGORITHM
    )
  end

  def session_token
    JWT.encode(
      payload.merge({ exp: SESSION_EXPIRATION.from_now.to_i }),
      SECRET,
      JWT_ALGORITHM
    )
  end

  private

  def payload
    {
      id: @user.id,
      token_version: @user.token_version,
      iat: DateTime.now.to_i
    }
  end
end