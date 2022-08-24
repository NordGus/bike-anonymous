class License::IngestionMailer < ApplicationMailer
  def file_processed
    @user = User.find(params[:user_id])
    @uploader = User.find_by(id: params[:uploader_id])

    mail(to: @user.email, subject: "File has been uploaded")
  end
end
