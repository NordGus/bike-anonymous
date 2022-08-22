require "test_helper"

class Api::SessionController::LogoutTest < ActionDispatch::IntegrationTest
  test "user successfully expires tokens" do
    token = login_token(:owner)

    post logout_api_session_index_url,
         headers: {
           "Authorization": "Bearer #{token}"
         }

    assert_response :success
    assert_not session[:jid].present?
    assert 5, users(:owner)
  end

  test "user fails to logout because invalid token" do
    post logout_api_session_index_url,
         headers: {
           "Authorization": "Bearer bad_token"
         }

    assert_response :unauthorized
    assert_not response.body.present?
    assert_not session[:jid].present?
  end
end
