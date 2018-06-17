class StaffMember < ApplicationRecord
  validates :login,  presence: true, length: { maximum: 50 },
                     uniqueness: true
  validates :password, presence: true,
                       length: { minimum: 6 },
                       allow_nil: true

  has_secure_password
end
