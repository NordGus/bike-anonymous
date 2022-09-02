require "test_helper"

class License::IngestionMailer::FileProcessedTest < ActionMailer::TestCase
  test "sends a notification to the partner when an ingestion file has been processed" do
    partner = users(:partner)
    email = ::License::IngestionMailer.with(user_id: partner.id).file_processed

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [partner.email]
    assert_equal email.from, ["application@ba.com"]
    assert_equal email.subject, "File has been uploaded"
    assert_match "License file has been processed!", email.body.encoded
  end

  test "sends a notification to the owner when a partner's ingestion file has been processed" do
    owner = users(:owner)
    partner = users(:partner)
    email = ::License::IngestionMailer.with(user_id: owner.id, uploader_id: partner.id).file_processed

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [owner.email]
    assert_equal email.from, ["application@ba.com"]
    assert_equal email.subject, "File has been uploaded"
    assert_match "License file has been processed!", email.body.encoded
    assert_match "Uploaded by: #{partner.email}", email.body.encoded
  end
end
