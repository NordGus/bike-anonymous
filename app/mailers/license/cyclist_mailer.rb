class License::CyclistMailer < LicenseMailer
  def new_license
    @cyclist = User.find(params[:cyclist_id])
    @license = ::License::Id.find(params[:license_id])

    mail(to: @cyclist.email, subject: "Here is your new license")
  end
end
