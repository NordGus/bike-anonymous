class License::IngestionMailer < ApplicationMailer
  def file_processed
    @user = params[:user]
    @uploader = params[:uploader]

    mail(to: @user.email, subject: "File has been uploaded")
  end
end
