class User < ApplicationRecord
    has_many :roles, autosave: true, dependent: :destroy
    has_many :courses, through: :roles
    has_many :posts, dependent: :destroy, as: :postable
    has_many :comments, dependent: :destroy, as: :commentable

    #validations for user name and email
    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
    validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
    before_save { self.email = email.downcase }
end
