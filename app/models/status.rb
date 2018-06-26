class Status < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 },
                   uniqueness: true
  before_validation :name_capitalize

  private
    # first letter name to uppercase
    def name_capitalize
      name.capitalize!
    end
end
