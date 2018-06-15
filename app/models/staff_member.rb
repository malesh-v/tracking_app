class StaffMember < ApplicationRecord
  validates :login,  presence: true, length: { maximum: 50 },
                     uniqueness: true
  validates :password, presence: true,
                       length: { minimum: 6 }

  has_secure_password
end
