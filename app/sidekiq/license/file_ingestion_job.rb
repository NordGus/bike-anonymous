require 'csv'

class License::FileIngestionJob
  include Sidekiq::Job

  def perform(file_id)
    ingestion_file = ::License::IngestionFile.find(file_id)

    CSV.parse(ingestion_file.file.download, headers: true) do |row|
      ::License::Scheduler.generate_license(
        {
          username: row["Username"],
          password: row["Password"],
          email: row["Email"],
          role: row["Role"],
          registered_at: row["LicenseRegistrationDate"],
          expires_at: row["LicenseExpirationDate"],
          code: row["LicenseCode"],
          first_name: row["FirstName"],
          last_name: row["LastName"],
          age: row["Age"]
        }
      )
    end

    ::License::Scheduler.check_file_ingestion(ingestion_file.id)
  end
end
