class License::Scheduler
  def self.ingest_file(file_id)
    ::License::FileIngestionJob.perform_async(file_id)
  end

  def self.generate_license(username, password, email, registered_at, expires_at, code, first_name, last_name, age)
    ::License::ProcessJob.perform_async(
      username,
      password,
      email,
      registered_at,
      expires_at,
      code,
      first_name,
      last_name,
      age
    )
  end

  def self.check_file_ingestion(file_id)
    ::License::FileCheckerJob.perform_in(5.minutes, file_id)
  end
end