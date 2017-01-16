class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :results, dependent: :destroy

  scope :learned_by, -> user_id {where user_id: user_id}
end
