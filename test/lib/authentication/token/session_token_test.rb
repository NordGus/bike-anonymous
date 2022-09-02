require 'test_helper'

class Authentication::Token::SessionTokenTest < ActiveSupport::TestCase
  test "should return a valid session token for the given user" do
    travel_to DateTime.new(2022, 9, 2)

    user = users(:owner)
    token = ::Authentication::Token.new(user).session_token

    assert token.present?

    assert_nothing_raised do
      payload = ::Authentication::Token.decode(token)

      assert payload[:headers].present?
      assert_equal "HS256", payload[:headers][:alg]

      assert payload[:payload].present?
      assert_equal DateTime.now.to_i, payload[:payload][:iat]
      assert_equal 7.days.from_now.to_i, payload[:payload][:exp]
      assert_equal user.id, payload[:payload][:id]
      assert_equal user.token_version, payload[:payload][:token_version]
    end
  end
end