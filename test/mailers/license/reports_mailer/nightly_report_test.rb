require "test_helper"

class License::ReportsMailer::NightlyReportTest < ActionMailer::TestCase
  test "sends a report to the owner with a summary of license ingestion files" do
    create_ingestion_file

    owner = users(:owner)
    from = 24.hours.ago
    ingestion_files = ::License::IngestionFile.where("processed_at >= ?", from).count
    licenses = ::License::Id.where("created_at >= ?", from).count
    cyclists = User.where(role: :cyclist).where("created_at >= ?", from).count
    email = ::License::ReportsMailer.with(user_id: owner.id).nightly_report

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [owner.email]
    assert_equal email.from, ["application@ba.com"]
    assert_equal email.subject, "Nightly Report"
    assert_match "Here is a summary of licenses' processing over the last 24 hours:", email.body.encoded
    assert_match "#{ingestion_files} files were processed.", email.body.encoded
    assert_match "#{licenses} licenses were issued.", email.body.encoded
    assert_match "#{cyclists} cyclists were added to the system.", email.body.encoded
  end

  private

  def create_ingestion_file
    ::License::IngestionFile.create!(
      uploader: users(:partner),
      file: {
        io: File.open(Rails.root.join("test", "fixtures", "files", "license", "processed_ingestion_file.csv")),
        filename: "ingestion_file.csv",
        content_type: "text/csv"
      }
    ).mark_as_processed
  end
end
