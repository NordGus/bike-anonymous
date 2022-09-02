require 'test_helper'

class Authentication::Token::DecodeTest < ActiveSupport::TestCase
  test "should return decoded token" do
    travel_to DateTime.new(2022, 9, 2)

    user = users(:owner)
    token = ::Authentication::Token.new(user).session_token

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

  test "should raise and exception when given token has expire" do
    travel_to DateTime.new(2022, 9, 2)

    user = users(:owner)
    token = ::Authentication::Token.new(user).session_token

    travel_to DateTime.new(2022, 10, 2)

    assert_raise(JWT::ExpiredSignature) do
      ::Authentication::Token.decode(token)
    end
  end
end