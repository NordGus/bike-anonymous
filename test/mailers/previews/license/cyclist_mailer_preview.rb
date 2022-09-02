# Preview all emails at http://localhost:3000/rails/mailers/license/ingestion_mailer
class License::CyclistMailerPreview < ActionMailer::Preview
  def new_license
    cyclist = User.where(role: :cyclist).first
    license = cyclist.license_ids.first

    ::License::CyclistMailer.with(cyclist_id: cyclist.id, license_id: license.id).new_license
  end
end
