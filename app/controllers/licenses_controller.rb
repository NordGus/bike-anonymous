class LicensesController < ApplicationController
  include Authenticable

  skip_before_action :authorize, only: [:login, :refresh]

  def ingestion_file
    user = User.find_by(username: params[:username])

    head(:unauthorized) and return unless user.present?
    head(:unauthorized) and return unless user.authenticate(params[:password])

    token = ::Authentication::Token.new(user)
    session[:jid] = token.session_token

    render json: { jwt: token.authentication_token }, status: :ok
  end

  def show
    current_user.revoke_tokens

    session[:jid] = nil

    head(:ok)
  end

  def refresh
    decoded_token = ::Authentication::Token.decode(session[:jid])
    user = User.find(decoded_token[:payload][:id])

    head(:unauthorized) and return unless user.token_version == decoded_token[:payload][:token_version]

    token = ::Authentication::Token.new(user)

    render json: { jwt: token.authentication_token }, status: :ok
  rescue => e
    logger.info "#{e.class}: Invalid Refresh Token"

    head(:unauthorized)
  end
end