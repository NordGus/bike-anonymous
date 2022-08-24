require 'csv'

class License::FileCheckerJob
  include Sidekiq::Job

  def perform(file_id)
    ingestion_file = find_ingestion_file(file_id)
    not_found = check_ingestion_file_progress(ingestion_file)

    if not_found.nil?
      complete_file_ingestion(ingestion_file)
      notify_uploader(ingestion_file)
      notify_owners(ingestion_file)
    else
      reschedule_check(ingestion_file.id)
    end
  end

  private

  def find_ingestion_file(file_id)
    ::License::IngestionFile.find(file_id)
  end

  def check_ingestion_file_progress(ingestion_file)
    CSV.parse(ingestion_file.file.download, headers: true) do |row|
      return row if ::License::Id.find_by(code: row["LicenseCode"]).nil?
    end

    nil
  end

  def complete_file_ingestion(ingestion_file)
    ingestion_file.mark_as_processed
  end

  def notify_uploader(ingestion_file)
    ::License::IngestionMailer.with(user_id: ingestion_file.uploader.id)
                              .file_processed
                              .deliver_later
  end

  def notify_owners(ingestion_file)
    User.where(role: :owner).each do |user|
      ::License::IngestionMailer.with(user_id: user.id, uploader_id: ingestion_file.uploader.id)
                                .file_processed
                                .deliver_later
    end
  end

  def reschedule_check(file_id)
    ::License::Scheduler.check_file_ingestion(file_id)
  end
end
