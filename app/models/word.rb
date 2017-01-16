class Word < ApplicationRecord
  belongs_to :category
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, allow_destroy: true,
    reject_if: proc { |attributes| attributes["content"].blank? }
  validates :content, presence: true, length: {maximum: 255}
  before_validation :must_have_a_correct_answer, :must_have_min_answer,
    :dont_have_duplicate_answer

  private
  def must_have_a_correct_answer
    unless self.answers.
      select{|answer| answer.is_correct}.size >= Settings.correct_answers_min
      errors.add "", I18n.t(:must_choose_a_correct_answer)
    end
  end

  def must_have_min_answer
    unless self.answers.size >= Settings.default_answer_limit
      errors.add "", I18n.t(:must_choose_min_answer,
        min: Settings.default_answer_limit)
    end
  end

  def dont_have_duplicate_answer
    duplicate_answer = self.answers.uniq{|answer| answer.content.squish}
    unless duplicate_answer.size == 0
      errors.add "", I18n.t(:have_duplicate_answer,
        content: duplicate_answer.first.content)
    end
  end
end
