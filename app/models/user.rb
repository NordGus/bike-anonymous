class User < ApplicationRecord
  has_secure_password

  enum role: { owner: 0, partner: 1, cyclist: 2 }, _prefix: :is

  validates :username, presence: true, uniqueness: true, length: { minimum: 6 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }
  validates :token_version, presence: true

  def revoke_tokens
    self.token_version += 1
    save(validate: false)
  end
end
