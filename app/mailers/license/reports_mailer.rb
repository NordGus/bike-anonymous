class License::ReportsMailer < ApplicationMailer
  def nightly_report
    from = 24.hours.ago

    @user = User.find(params[:user_id])
    @ingestion_files = ::License::IngestionFile.where("processed_at >= ?", from)
    @licenses = ::License::Id.where("created_at >= ?", from)
    @cyclists = User.where(role: :cyclist).where("created_at >= ?", from)

    mail(to: @user.email, subject: "Nightly Report")
  end
end
