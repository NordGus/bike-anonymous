require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "revoke all active tokens for user" do
    user = users(:owner)

    assert_equal 4, user.token_version

    user.revoke_tokens

    assert_equal 5, user.token_version
  end
end
