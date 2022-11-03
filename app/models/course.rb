class Course < ApplicationRecord
    has_many :roles, autosave: true
    has_many :users, through: :roles
    has_many :posts

    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 50 }
end
