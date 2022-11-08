class Comment < ApplicationRecord
  # belongs_to :user
  # belongs_to :post
  belongs_to :commentable, polymorphic: true, optional: true

  validates :body, presence: true
end
