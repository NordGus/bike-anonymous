require 'test_helper'
class License::FileIngestionJobTest < ActiveSupport::TestCase
  def teardown
    super()

    ingestion_file.destroy
  end

  test "is successful" do
    assert_difference "::License::ProcessJob.jobs.length", 1 do
      assert_difference "::License::FileCheckerJob.jobs.length", 1 do
        ::License::FileIngestionJob.new.perform(ingestion_file.id)
      end
    end
  end

  test "fails because file_id is invalid" do
    job = ::License::FileIngestionJob.new

    assert_raise(ActiveRecord::RecordNotFound) { job.perform("bad_id") }
  end

  private

  def ingestion_file
    @ingestion_file = ::License::IngestionFile.create!(
      uploader: users(:partner),
      file: {
        io: File.open(Rails.root.join("test", "fixtures", "files", "license", "ingestion_file.csv")),
        filename: "ingestion_file.csv",
        content_type: "text/csv"
      }
    )
  end
end
