class Api::SessionController < ApplicationController
  include Authenticable

  skip_before_action :authorize, only: [:login, :refresh]

  def login
    user = User.find_by(username: params[:username])

    head(:unauthorized) and return unless user.present?
    head(:unauthorized) and return unless user.authenticate(params[:password])

    token = ::Authentication::TokenGenerator.new(user)
    session[:jid] = token.session_token

    render json: { jwt: token.authentication_token }, status: :ok
  end

  def logout
    current_user.revoke_tokens

    session[:jid] = nil

    head(:ok)
  end

  def refresh
    decoder = ::Authentication::TokenDecoder.new(session[:jid])
    decoder.decode

    user = User.find(decoder.payload[:id])

    head(:unauthorized) and return unless user.token_version == decoder.payload[:token_version]

    token = ::Authentication::TokenGenerator.new(user)

    render json: { jwt: token.authentication_token }, status: :ok
  rescue => e
    logger.info "#{e.class}: Invalid Refresh Token"

    head(:unauthorized)
  end
end