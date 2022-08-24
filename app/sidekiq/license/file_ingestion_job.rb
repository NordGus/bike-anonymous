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
        {
          username: row["Username"],
          password: row["Password"],
          email: row["Email"],
          registered_at: row["LicenseRegistrationDate"],
          expires_at: row["LicenseExpirationDate"],
          code: row["LicenseCode"],
          first_name: row["FirstName"],
          last_name: row["LastName"],
          age: row["Age"]
        }
      )
    end
  end

  def schedule_check(file_id)
    ::License::Scheduler.check_file_ingestion(file_id)
  end
end
