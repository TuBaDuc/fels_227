class Answer < ApplicationRecord
  belongs_to :word, optional: true
  validates :content, presence: true, length: {maximum: 255}

  scope :correct, -> {where is_correct: true}
end
