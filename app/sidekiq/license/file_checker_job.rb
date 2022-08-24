require 'csv'

class License::FileCheckerJob
  include Sidekiq::Job

  def perform(file_id)
    ingestion_file = ::License::IngestionFile.find(file_id)

    @not_found = nil

    CSV.parse(ingestion_file.file.download, headers: true) do |row|
      if ::License::Id.find_by(code: row["LicenseCode"]).nil?
        @not_found = row
        break
      end
    end

    if @not_found.nil?
      ingestion_file.mark_as_processed

      ::License::IngestionMailer
        .with(user: ingestion_file.uploader)
        .file_processed
        .deliver_later

      User.where(role: :owner).each do |user|
        ::License::IngestionMailer
          .with(user: user, uploader: ingestion_file.uploader)
          .file_processed
          .deliver_later
      end
    else
      ::License::Scheduler.check_file_ingestion(ingestion_file.id)
    end
  end
end
