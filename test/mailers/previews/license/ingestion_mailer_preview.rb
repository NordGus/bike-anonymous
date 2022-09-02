# Preview all emails at http://localhost:3000/rails/mailers/license/ingestion_mailer
class License::IngestionMailerPreview < ActionMailer::Preview
  def file_processed_for_partner
    partner = User.where(role: :partner).first

    ::License::IngestionMailer.with(user_id: partner.id).file_processed
  end

  def file_processed_for_owner
    owner = User.where(role: :owner).first
    partner = User.where(role: :partner).first

    ::License::IngestionMailer.with(user_id: owner.id, uploader_id: partner.id).file_processed
  end
end
