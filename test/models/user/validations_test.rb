require "test_helper"

class User::ValidationsTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      username: "test_user",
      password: "super_secret",
      email: "test@example.com"
    )

    assert user.valid?
  end

  test "invalid user because username is blank" do
    user = User.new(
      password: "super_secret",
      email: "test@example.com"
    )

    assert_not user.valid?
    assert_equal [{:error=>:blank}, {:error=>:too_short, :count=>6}], user.errors.details[:username]
  end

  test "invalid user because username is not unique" do
    user = User.new(
      username: users(:owner).username,
      password: "super_secret",
      email: "test@example.com"
    )

    assert_not user.valid?
    assert_equal [{error: :taken, value: users(:owner).username}], user.errors.details[:username]
  end

  test "invalid user because username is too short" do
    user = User.new(
      username: "short",
      password: "super_secret",
      email: "test@example.com"
    )

    assert_not user.valid?
    assert_equal [{error: :too_short, count: 6}], user.errors.details[:username]
  end

  test "invalid user because email is blank" do
    user = User.new(
      username: "test_user",
      password: "super_secret"
    )

    assert_not user.valid?
    assert_equal [{error: :blank}], user.errors.details[:email]
  end

  test "invalid user because email is not unique" do
    user = User.new(
      username: "test_user",
      password: "super_secret",
      email: users(:owner).email
    )

    assert_not user.valid?
    assert_equal [{error: :taken, value: users(:owner).email}], user.errors.details[:email]
  end

  test "invalid user because password is blank" do
    user = User.new(
      username: "test_user",
      email: "test@example.com"
    )

    assert_not user.valid?
    assert_equal [{:error=>:blank}, {:error=>:too_short, :count=>8}], user.errors.details[:password]
  end

  test "invalid user because password is too short" do
    user = User.new(
      username: "test_user",
      password: "super",
      email: "test@example.com"
    )

    assert_not user.valid?
    assert_equal [{:error=>:too_short, :count=>8}], user.errors.details[:password]
  end

  test "invalid user because token_version is blank" do
    user = User.new(
      username: "test_user",
      password: "super_secret",
      email: "test@example.com",
      token_version: nil
    )

    assert_not user.valid?
    assert_equal [{error: :blank}], user.errors.details[:token_version]
  end
end
