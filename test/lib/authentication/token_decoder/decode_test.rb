class Authentication::TokenDecoder::DecodeTest < ActiveSupport::TestCase
  test "should decode the given token" do
    travel_to DateTime.new(2022, 9, 2)

    token = generate_token
    decoder = ::Authentication::TokenDecoder.new(token)

    assert decoder.decode
  end

  test "should populate the headers" do
    travel_to DateTime.new(2022, 9, 2)

    token = generate_token
    decoder = ::Authentication::TokenDecoder.new(token)

    assert decoder.decode
    assert decoder.headers.present?
    assert_equal "HS256", decoder.headers[:alg]
  end

  test "should populate the payload" do
    travel_to DateTime.new(2022, 9, 2)

    token = generate_token
    decoder = ::Authentication::TokenDecoder.new(token)

    assert decoder.decode
    assert decoder.payload.present?
    assert_equal DateTime.now.to_i, decoder.payload[:iat]
    assert_equal 7.days.from_now.to_i, decoder.payload[:exp]
    assert_equal user.id, decoder.payload[:id]
    assert_equal user.token_version, decoder.payload[:token_version]
  end

  test "should raise and exception when given an expired token" do
    travel_to DateTime.new(2022, 9, 2)

    token = generate_token

    travel_to DateTime.new(2022, 10, 2)

    assert_raise(JWT::ExpiredSignature) { ::Authentication::TokenDecoder.new(token).decode }
  end

  private

  def generate_token
    ::Authentication::TokenGenerator.new(user).session_token
  end

  def user
    users(:owner)
  end
end