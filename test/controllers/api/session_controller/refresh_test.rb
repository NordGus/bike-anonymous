require "test_helper"

class Api::SessionController::RefreshTest < ActionDispatch::IntegrationTest
  test "user successfully refreshes tokens" do
    login_token(:owner)

    post refresh_api_session_index_url

    assert_response :success
    assert response.parsed_body["jwt"].present?
    assert session[:jid].present?
  end

  test "user fails to refresh token because invalid session token" do
    post refresh_api_session_index_url

    assert_response :unauthorized
    assert_not response.body.present?
    assert_not session[:jid].present?
  end
end
