class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true
  validates :content, presence: true, length: {maximum: 255}

  scope :all_word, -> user_id{}
  scope :learned, -> user_id{where "id in (select word_id from answers where
    is_correct = '1')"}
  scope :not_learn, -> user_id{where "id not in (select word_id from answers
    where is_correct = '1')"}
end
