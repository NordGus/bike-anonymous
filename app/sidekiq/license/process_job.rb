class License::ProcessJob
  include Sidekiq::Job

  def perform(args)
    cyclist = find_or_initialize_cyclist_user(args["username"])

    if cyclist.new_record?
      create_cyclist_user(cyclist, args["password"], args["email"])
    end

    license = create_license!(
      cyclist: cyclist,
      registered_at: args["registered_at"],
      expires_at: args["expires_at"],
      code: args["code"],
      first_name: args["first_name"],
      last_name: args["last_name"],
      age: args["age"]
    )

    notify_cyclist(cyclist, license)
  end

  def find_or_initialize_cyclist_user(username)
    User.find_or_initialize_by(username: username)
  end

  def create_cyclist_user(user, password, email)
    user.password = password
    user.password_confirmation = password
    user.email = email
    user.role = :cyclist

    user.save!
  end

  def create_license!(
    cyclist:,
    registered_at:,
    expires_at:,
    code:,
    first_name:,
    last_name:,
    age:
  )
    ::License::Id.create!(
      cyclist: cyclist,
      registered_at: registered_at,
      expires_at: expires_at,
      code: code,
      first_name: first_name,
      last_name: last_name,
      age: age
    )
  end

  def notify_cyclist(cyclist, license)
    ::License::CyclistMailer.with(cyclist_id: cyclist.id, license_id: license.id).new_license.deliver_later
  end
end
