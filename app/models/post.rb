class Post < ApplicationRecord
  belongs_to :user
  belongs_to :class
  has_many :comments
end
