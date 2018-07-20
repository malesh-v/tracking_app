class ActivityLog < ApplicationRecord
  belongs_to :ticket
  default_scope -> { order(created_at: :desc) }
end