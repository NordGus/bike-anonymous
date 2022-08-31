require "test_helper"

class Api::License::CyclistsController::ShowTest < ActionDispatch::IntegrationTest
  test "should return unauthorized response when the user is not logged in" do
    get api_license_cyclist_path(id: license_ids(:cyclist_1_license).code)

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return unauthorized response when user is not a partner" do
    token = login_token(:owner)

    get api_license_cyclist_path(id: license_ids(:cyclist_1_license).code),
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return unauthorized response when license don't belongs to cyclist" do
    token = login_token(:cyclist_1)

    get api_license_cyclist_path(id: license_ids(:cyclist_2_license).code),
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :unauthorized
    assert_not response.body.present?
  end

  test "should return not found response when bad id is passed" do
    token = login_token(:cyclist_1)

    get api_license_cyclist_path(id: "bad_code"),
         headers: { "Authorization": "Bearer #{token}" }

    assert_response :not_found
    assert_not response.body.present?
  end

  test "should return success response when an partner is logged in" do
    token = login_token(:cyclist_1)

    get api_license_cyclist_path(id: license_ids(:cyclist_1_license).code),
         headers: { "Authorization": "Bearer #{token}" }


    assert_response :success
    pdf = ::PDF::Inspector::Text.analyze(response.body)

    assert_equal "License #{license_ids(:cyclist_1_license).code}", pdf.strings[0]
    assert_equal "Registration Date: #{license_ids(:cyclist_1_license).registered_at.strftime("%B %d %Y")}", pdf.strings[1]
    assert_equal "Expiration Date: #{license_ids(:cyclist_1_license).expires_at.strftime("%B %d %Y")}", pdf.strings[2]
    assert_equal "First Name: #{license_ids(:cyclist_1_license).first_name}", pdf.strings[3]
    assert_equal "Last Name: #{license_ids(:cyclist_1_license).last_name}", pdf.strings[4]
  end
end