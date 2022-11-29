class Role < ApplicationRecord
    paginates_per 15
    belongs_to :user
    belongs_to :course
end
