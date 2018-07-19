class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :commentable, polymorphic: true
end
