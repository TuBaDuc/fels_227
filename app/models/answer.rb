class Answer < ApplicationRecord
  belongs_to :word, optional: true
  has_many :results, dependent: :destroy
  validates :content, presence: true, length: {maximum: 255}

  scope :correct, -> {where is_correct: true}
end
