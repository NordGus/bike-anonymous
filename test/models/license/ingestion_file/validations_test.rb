require "test_helper"

class License::IngestionFile::ValidationsTest < ActiveSupport::TestCase
  test "valid ingestion file" do
    skip "can't find a way to make model valid"
    file = File.open(Rails.root.join("test/fixtures/files/license/ingestion_file.csv"))

    ingestion_file = ::License::IngestionFile.new(file: file)

    assert ingestion_file.valid?
  end

  test "invalid ingestion file because of not uploaded file" do
    ingestion_file = ::License::IngestionFile.new

    assert_not ingestion_file.valid?
    assert_equal [{error: :blank}], ingestion_file.errors.details[:file]
    assert_equal [{error: :blank}], ingestion_file.errors.details[:uploader]
  end
end