class ActivityLog < ApplicationRecord
  belongs_to :ticket
  default_scope -> { order(id: :desc) }
end