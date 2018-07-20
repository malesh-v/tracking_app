class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true
  default_scope -> { order(created_at: :desc) }
end
