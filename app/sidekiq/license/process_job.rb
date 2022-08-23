class License::ProcessJob
  include Sidekiq::Job

  def perform(args)
    user = User.find_or_initialize_by(username: args["username"])

    create_user(user, args["password"], args["email"], args["role"].downcase) if user.new_record?

    ::License::Id.create!(
      cyclist: user,
      registered_at: args["registered_at"],
      expires_at: args["expires_at"],
      code: args["code"],
      first_name: args["first_name"],
      last_name: args["last_name"],
      age: args["age"]
    )
  end

  def create_user(user, password, email, role)
    user.password = password
    user.password_confirmation = password
    user.email = email
    user.role = role

    user.save!
  end
end
