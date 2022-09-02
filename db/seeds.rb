if Rails.env.development?
  _owner = User.create(
    username: "BikesAnonymous",
    password: "super_secret",
    password_confirmation: "super_secret",
    email: "owner@ba.com",
    role: :owner
  )

  _partner = User.create(
    username: "PartnerCenter",
    password: "super_secret",
    password_confirmation: "super_secret",
    email: "partner@center.com",
    role: :partner
  )

  cyclist = User.create(
    username: "Cyclist1",
    password: "super_secret",
    password_confirmation: "super_secret",
    email: "cyclist1@example.com",
    role: :cyclist
  )

  _licence = License::Id.create(
    cyclist: cyclist,
    registered_at: 1.month.ago,
    expires_at: 1.month.ago + 1.year.from_now,
    code: "seed-license-1",
    first_name: "John",
    last_name: "Wick",
    age: 40
  )
end
