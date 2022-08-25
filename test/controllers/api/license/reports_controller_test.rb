require "test_helper"

class Api::License::ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get nightly" do
    get api_license_reports_nightly_url
    assert_response :success
  end
end
