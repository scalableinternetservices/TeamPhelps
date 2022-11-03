class Post < ApplicationRecord
  belongs_to :user
  belongs_to :class
  has_many :comments

  validates_presence_of :user
  validates_presence_of :class
end
