class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :words, through: :results
  has_many :answers, through: :results
  has_many :results, dependent: :destroy
  accepts_nested_attributes_for :results

  before_create :create_words

  scope :learned_by, -> user_id {where user_id: user_id}

  private
  def create_words
    self.words = self.category.words.order("RAND()")
      .limit Settings.word_of_lesson_limit
  end
end
