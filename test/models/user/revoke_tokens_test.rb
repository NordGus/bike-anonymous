require "test_helper"

class User::RevokeTokensTest < ActiveSupport::TestCase
  test "expires active tokens for user" do
    user = users(:owner)
    authentication_token = ::Authentication::Token.new(user).authentication_token
    session_token = ::Authentication::Token.new(user).session_token

    assert_equal user.token_version, ::Authentication::Token.decode(authentication_token)[:payload][:token_version]
    assert_equal user.token_version, ::Authentication::Token.decode(session_token)[:payload][:token_version]

    user.revoke_tokens

    assert_equal 5, user.token_version
    assert_not_equal user.token_version, ::Authentication::Token.decode(authentication_token)[:payload][:token_version]
    assert_not_equal user.token_version, ::Authentication::Token.decode(session_token)[:payload][:token_version]
  end
end