class Post < ApplicationRecord
  # belongs_to :user
  # belongs_to :class
  belongs_to :postable, polymorphic: true
  has_many :comments

  # validates_presence_of :user
  # validates_presence_of :class

  # validations for post title and body
  validates :title, presence: true, length: { minimum: 3, maximum: 15 }
  validates :body, presence: true, length: { minimum: 8, maximum: 100 }
end
