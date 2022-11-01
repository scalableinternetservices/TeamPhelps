class User < ApplicationRecord
    has_many :roles
    has_many :courses, through: :roles
    has_many :posts
    has_many :comments
end
