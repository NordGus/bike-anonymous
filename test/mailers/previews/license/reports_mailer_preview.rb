# Preview all emails at http://localhost:3000/rails/mailers/license/reports_mailer
class License::ReportsMailerPreview < ActionMailer::Preview
  def nightly_report
    owner = User.where(role: :owner).first

    ::License::ReportsMailer.with(user_id: owner.id).nightly_report
  end
end
