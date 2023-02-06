class License::ProcessJob
  include Sidekiq::Job

  def perform(username, password, email, registered_at, expires_at, code, first_name, last_name, age)
    cyclist = find_or_initialize_cyclist!(username, password, email)

    license = create_license!(
      cyclist: cyclist,
      registered_at: registered_at,
      expires_at: expires_at,
      code: code,
      first_name: first_name,
      last_name: last_name,
      age: age
    )

    notify_cyclist(cyclist, license)
  end

  def find_or_initialize_cyclist!(username, password, email)
    User.create_with(email: email, role: :cyclist, password: password, password_confirmation: password)
        .find_or_create_by!(username: username)
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
