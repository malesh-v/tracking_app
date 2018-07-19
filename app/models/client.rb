class Client < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :comments, as: :commentable
  has_many :tickets

  before_save :downcase_email
  before_save :capitalize_name

  validates :email, presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :name,  presence: true,
            length: { maximum: 50 }
  has_many :comments, as: :commentable

  private

    # Converts email to all lower-case.
    def downcase_email
      email.downcase! # eq self.email = email.downcase
    end

    # Converts first later each word to upper case
    def capitalize_name
      self.name = name.split.map(&:capitalize).join(' ')
    end
end
