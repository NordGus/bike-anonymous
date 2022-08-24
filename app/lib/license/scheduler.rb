class License::Scheduler
  def self.ingest_file(file_id)
    ::License::FileIngestionJob.perform_async(file_id)
  end

  def self.generate_license(license_args)
    ::License::ProcessJob.perform_async(license_args)
  end

  def self.check_file_ingestion(file_id)
    ::License::FileCheckerJob.perform_in(5.minutes, file_id)
  end
end