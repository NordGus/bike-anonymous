class Api::License::FilesController < ApplicationController
  include Authenticable

  before_action :authorize_partner

  def ingest
    file = ::License::IngestionFile.create(file: params[:file], uploader: current_user)

    ::License::Scheduler.ingest_file(file.id)

    head(:ok)
  end
end