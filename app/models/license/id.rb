class License::Id < ApplicationRecord
  belongs_to :cyclist, class_name: "User", foreign_key: :cyclist_id

  validates :code, presence: true, uniqueness: true
  validates_presence_of :registered_at, :expires_at, :age, :first_name, :last_name
end
