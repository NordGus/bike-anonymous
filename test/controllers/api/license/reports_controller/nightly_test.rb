require "test_helper"

class Api::License::ReportsController::NightlyTest < ActionDispatch::IntegrationTest
  test "should return unauthorized response when the user is not logged in" do
    post nightly_api_license_reports_path

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return unauthorized response when user is not an owner" do
    token = login_token(:partner)

    post nightly_api_license_reports_path,
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return success response when an owner is logged in" do
    token = login_token(:owner)

    post nightly_api_license_reports_path,
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :success
    assert_not response.body.present?
  end
end