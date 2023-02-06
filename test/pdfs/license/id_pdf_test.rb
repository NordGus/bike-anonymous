class License::IdPdfTest < ActiveSupport::TestCase
  test "should return success response when an partner is logged in" do
    license = license_ids(:cyclist_1_license)
    pdf = ::License::IdPdf.new(license)

    inspector = ::PDF::Inspector::Text.analyze(pdf.render)

    assert_equal "License #{license.code}", inspector.strings[0]
    assert_equal "Registration Date: #{license.registered_at.strftime("%B %d %Y")}", inspector.strings[1]
    assert_equal "Expiration Date: #{license.expires_at.strftime("%B %d %Y")}", inspector.strings[2]
    assert_equal "First Name: #{license.first_name}", inspector.strings[3]
    assert_equal "Last Name: #{license.last_name}", inspector.strings[4]
  end
end
