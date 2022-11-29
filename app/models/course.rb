class Course < ApplicationRecord
    paginates_per 15
    has_many :roles, autosave: true, dependent: :destroy
    has_many :users, through: :roles
    has_many :posts, dependent: :destroy

    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 50 }
end
