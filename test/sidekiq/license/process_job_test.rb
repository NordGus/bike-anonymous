require 'test_helper'
class License::ProcessJobTest < ActiveSupport::TestCase
  test "is successful creating user" do
    assert_difference "User.count", 1 do
      assert_difference "::License::Id.count", 1 do
        ::License::ProcessJob.new.perform(license_args.merge(new_user_args))
      end
    end
  end

  test "is successful existing user" do
    assert_difference "User.count", 0 do
      assert_difference "::License::Id.count", 1 do
        ::License::ProcessJob.new.perform(license_args.merge(existing_user_args))
      end
    end
  end

  test "fails because of an error creating user" do
    job = ::License::ProcessJob.new

    assert_raise(ActiveRecord::RecordInvalid) do
      job.perform(license_args.merge(new_user_args).merge("password" => "short"))
    end
  end

  test "fails because of an error creating license" do
    job = ::License::ProcessJob.new

    assert_raise(ActiveRecord::RecordInvalid) do
      job.perform(
        license_args
          .merge(new_user_args)
          .merge("code" => license_ids(:cyclist_1_license).code)
      )
    end
  end

  private

  def new_user_args
    {
      "username" => "test_user",
      "password" => "super_secret",
      "email" => "test@example.com"
    }
  end

  def existing_user_args
    {
      "username" => users(:cyclist_1).username,
      "password" => "secret",
      "email" => users(:cyclist_1).email
    }
  end

  def license_args
    {
      "code" => "test",
      "registered_at" => 3.weeks.ago,
      "expires_at" => 3.weeks.ago + 1.year,
      "age" => 40,
      "first_name" => "John",
      "last_name" => "Wick"
    }
  end
end
