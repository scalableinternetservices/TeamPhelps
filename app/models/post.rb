class Post < ApplicationRecord
  # belongs_to :user
  # belongs_to :class
  belongs_to :postable, polymorphic: true
  has_many :comments

  # validates_presence_of :user
  # validates_presence_of :class
end
