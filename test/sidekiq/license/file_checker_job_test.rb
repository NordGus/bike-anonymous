require 'test_helper'
class License::FileCheckerJobTest < ActiveSupport::TestCase
  def teardown
    super()

    valid_ingestion_file.destroy
    invalid_ingestion_file.destroy
  end

  test "is successful" do
    ::License::FileCheckerJob.new.perform(valid_ingestion_file.id)

    @valid_ingestion_file.reload

    assert @valid_ingestion_file.processed_at.present?
  end

  test "retries because there's unprocessed licenses in the ingestion file" do
    assert_difference "::License::FileCheckerJob.jobs.length", 1 do
      ::License::FileCheckerJob.new.perform(invalid_ingestion_file.id)
    end
  end

  test "fails because file_id is invalid" do
    job = ::License::FileCheckerJob.new

    assert_raise(ActiveRecord::RecordNotFound) { job.perform("bad_id") }
  end

  private

  def invalid_ingestion_file
    @invalid_ingestion_file = ::License::IngestionFile.create!(
      uploader: users(:partner),
      file: {
        io: File.open(Rails.root.join("test", "fixtures", "files", "license", "ingestion_file.csv")),
        filename: "ingestion_file.csv",
        content_type: "text/csv"
      }
    )
  end

  def valid_ingestion_file
    @valid_ingestion_file = ::License::IngestionFile.create!(
      uploader: users(:partner),
      file: {
        io: File.open(Rails.root.join("test", "fixtures", "files", "license", "processed_ingestion_file.csv")),
        filename: "ingestion_file.csv",
        content_type: "text/csv"
      }
    )
  end
end
