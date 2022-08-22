require "test_helper"

class Api::SessionController::LoginTest < ActionDispatch::IntegrationTest
  test "user successfully authenticates" do
    post login_api_session_index_url,
         params: {
           username: "BikesAnonymous",
           password: "secret"
         }

    assert_response :success
    assert response.parsed_body["jwt"].present?
    assert session[:jid].present?
  end

  test "user fails to authenticate with bad username" do
    post login_api_session_index_url,
         params: {
           username: "BadUsername",
           password: "secret"
         }

    assert_response :unauthorized
    assert_not response.body.present?
    assert_not session[:jid].present?
  end

  test "user fails to authenticate with bad password" do
    post login_api_session_index_url,
         params: {
           username: "BikesAnonymous",
           password: "bad_secret"
         }

    assert_response :unauthorized
    assert_not response.body.present?
    assert_not session[:jid].present?
  end
end
