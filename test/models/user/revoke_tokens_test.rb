require "test_helper"

class User::RevokeTokensTest < ActiveSupport::TestCase
  test "expires active tokens for user" do
    user = users(:owner)
    token_generator = ::Authentication::TokenGenerator.new(user)
    authentication_decoder = ::Authentication::TokenDecoder.new(token_generator.authentication_token)
    session_decoder = ::Authentication::TokenDecoder.new(token_generator.session_token)

    authentication_decoder.decode
    session_decoder.decode

    assert_equal user.token_version, authentication_decoder.payload[:token_version]
    assert_equal user.token_version, session_decoder.payload[:token_version]

    user.revoke_tokens

    assert_equal 5, user.token_version
    assert_not_equal user.token_version, authentication_decoder.payload[:token_version]
    assert_not_equal user.token_version, session_decoder.payload[:token_version]
  end
end