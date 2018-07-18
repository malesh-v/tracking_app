class ActivityLog < ApplicationRecord
  belongs_to :ticket

  class << self
    def save_message(ticket)
      ticket
    end
  end
end