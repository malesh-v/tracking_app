class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :commentable, polymorphic: true

  default_scope -> { order(created_at: :desc) }
  validates :content, presence: true
end