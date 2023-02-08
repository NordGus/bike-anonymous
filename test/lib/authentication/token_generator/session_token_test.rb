require 'test_helper'

class Authentication::TokenGenerator::SessionTokenTest < ActiveSupport::TestCase
  test "should return a valid authentication token for the given user" do
    travel_to DateTime.new(2022, 9, 2)

    token = ::Authentication::TokenGenerator.new(user).session_token

    assert token.present?

    decoder = ::Authentication::TokenDecoder.new(token)

    assert decoder.decode
  end

  test "should return a token with the expected headers" do
    travel_to DateTime.new(2022, 9, 2)

    token = ::Authentication::TokenGenerator.new(user).session_token
    decoder = ::Authentication::TokenDecoder.new(token)

    decoder.decode

    assert decoder.headers.present?
    assert_equal "HS256", decoder.headers[:alg]
  end

  test "should return a token with the expected payload" do
    travel_to DateTime.new(2022, 9, 2)

    token = ::Authentication::TokenGenerator.new(user).session_token
    decoder = ::Authentication::TokenDecoder.new(token)

    decoder.decode

    assert decoder.payload.present?
    assert_equal DateTime.now.to_i, decoder.payload[:iat]
    assert_equal 7.days.from_now.to_i, decoder.payload[:exp]
    assert_equal user.id, decoder.payload[:id]
    assert_equal user.token_version, decoder.payload[:token_version]
  end

  private

  def user
    users(:owner)
  end
end