require 'csv'

class License::FileIngestionJob
  include Sidekiq::Job

  def perform(file_id)
    ingestion_file = find_ingestion_file(file_id)

    process_file(ingestion_file)

    schedule_check(ingestion_file.id)
  end

  private

  def find_ingestion_file(file_id)
    ::License::IngestionFile.find(file_id)
  end

  def process_file(ingestion_file)
    CSV.parse(ingestion_file.file.download, headers: true) do |row|
      ::License::Scheduler.generate_license(
        row["Username"],
        row["Password"],
        row["Email"],
        row["LicenseRegistrationDate"],
        row["LicenseExpirationDate"],
        row["LicenseCode"],
        row["FirstName"],
        row["LastName"],
        row["Age"]
      )
    end
  end

  def schedule_check(file_id)
    ::License::Scheduler.check_file_ingestion(file_id)
  end
end
