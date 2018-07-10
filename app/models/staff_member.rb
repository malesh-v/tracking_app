class StaffMember < ApplicationRecord
  validates :login,  presence: true, length: { maximum: 50 },
            uniqueness: true
  validates :password, presence: true,
            length: { minimum: 6 },
            allow_nil: true
  has_secure_password
  has_many :tickets

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = StaffMember.encrypt(StaffMember.new_remember_token)
    end
end
