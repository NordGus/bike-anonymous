require "test_helper"

class License::Id::ValidationsTest < ActiveSupport::TestCase
  test "valid id" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert id.valid?
  end

  test "invalid id because cyclist is blank" do
    id = ::License::Id.new(
      code: "test",
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:cyclist]
  end

  test "invalid id because code is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:code]
  end

  test "invalid id because code is not unique" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: license_ids(:cyclist_1_license).code,
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :taken, value: license_ids(:cyclist_1_license).code}], id.errors.details[:code]
  end

  test "invalid id because registered_at is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:registered_at]
  end

  test "invalid id because expires_at is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      registered_at: 3.weeks.ago,
      age: 40,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:expires_at]
  end

  test "invalid id because age is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      first_name: "John",
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:age]
  end

  test "invalid id because first_name is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      last_name: "Wick"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:first_name]
  end

  test "invalid id because last_name is blank" do
    id = ::License::Id.new(
      cyclist: users(:cyclist_1),
      code: "test",
      registered_at: 3.weeks.ago,
      expires_at: 3.weeks.ago + 1.year,
      age: 40,
      first_name: "John"
    )

    assert_not id.valid?
    assert_equal [{error: :blank}], id.errors.details[:last_name]
  end
end