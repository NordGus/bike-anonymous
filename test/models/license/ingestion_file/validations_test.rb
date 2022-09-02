require "test_helper"

class License::IngestionFile::ValidationsTest < ActiveSupport::TestCase
  test "valid ingestion file" do
    ingestion_file = ::License::IngestionFile.new(
      file: {
        io: file,
        filename: "ingestion_file.csv"
      },
      uploader: users(:partner)
    )

    assert ingestion_file.valid?
  end

  test "invalid ingestion file because of not uploaded file" do
    ingestion_file = ::License::IngestionFile.new(
      uploader: users(:partner)
    )

    assert_not ingestion_file.valid?
    assert_equal [{error: :blank}], ingestion_file.errors.details[:file]
  end

  test "invalid ingestion file because uploader is blank" do
    ingestion_file = ::License::IngestionFile.new(
      file: {
        io: file,
        filename: "ingestion_file.csv"
      }
    )

    assert_not ingestion_file.valid?
    assert_equal [{error: :blank}], ingestion_file.errors.details[:uploader]
  end

  private

  def file
    @file ||= File.open(Rails.root.join("test", "fixtures", "files", "license", "ingestion_file.csv"))
  end
end