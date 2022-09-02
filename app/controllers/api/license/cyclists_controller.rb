class Api::License::CyclistsController < ApplicationController
  include Authenticable

  before_action :authorize_cyclist

  def show
    id = ::License::Id.find_by!(code: params[:id])

    head(:unauthorized) and return if current_user.id != id.cyclist_id

    pdf = ::License::IdPdf.new(id)

    send_data(
      pdf.render,
      filename: "licence-#{id.code}",
      type: "application/pdf",
      disposition: "inline"
    )
  rescue ActiveRecord::RecordNotFound => not_found
    logger.error not_found.message
    logger.error not_found.backtrace&.join("\n")

    head(:not_found)
  end
end