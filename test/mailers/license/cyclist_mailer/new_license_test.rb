require "test_helper"

class License::IngestionMailer::NewLicenseTest < ActionMailer::TestCase
  test "sends a notification to the cyclist with a link to access their license" do
    cyclist = users(:cyclist_1)
    license = license_ids(:cyclist_1_license)
    email = ::License::CyclistMailer.with(cyclist_id: cyclist.id, license_id: license.id).new_license

    assert_emails 1 do
      email.deliver_later
    end

    assert_equal email.to, [cyclist.email]
    assert_equal email.from, ["application@ba.com"]
    assert_equal email.subject, "Here is your new license"
    assert_match "#{license.first_name}, your license is available", email.body.encoded
  end
end
