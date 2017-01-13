class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user

  scope :learned_by, -> user_id {where user_id: user_id}
end
