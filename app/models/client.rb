class Client < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  #has_many :ticketcomments, as: :commentable

  before_save :downcase_email
  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :name,  presence: true,
            length: { maximum: 50 }

  private

    # Converts email to all lower-case.
    def downcase_email
      email.downcase! # eq self.email = email.downcase
    end
end
