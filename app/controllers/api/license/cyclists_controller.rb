class Api::License::CyclistsController < ApplicationController
  include Authenticable

  before_action :authorize_cyclist

  def show
    id = ::License::Id.find_by(code: params[:id])

    pdf = ::License::IdPdf.new(id)

    send_data(
      pdf.render,
      filename: "licence-#{id.code}",
      type: "application/pdf",
      disposition: "inline"
    )
  end
end