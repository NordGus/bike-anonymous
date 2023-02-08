module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authorize
  end

  def authorize
    current_user
  rescue => e
    logger.info "#{e.class}: Unauthorized Access"

    head(:unauthorized)
  end

  def authorize_owner
    head(:unauthorized) unless current_user.is_owner?
  end

  def authorize_partner
    head(:unauthorized) unless current_user.is_partner?
  end

  def authorize_cyclist
    head(:unauthorized) unless current_user.is_cyclist?
  end

  def current_user
    @current_user ||= begin
      encoded_token = request.headers["Authorization"]&.split("Bearer ")&.last
      decoder = ::Authentication::TokenDecoder.new(encoded_token)
      decoder.decode

      user = User.find(decoder.payload[:id])

      raise StandardError, "invalid token" unless user.token_version == decoder.payload[:token_version]

      user
    end
  end
end
