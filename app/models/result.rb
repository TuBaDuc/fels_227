class Result < ApplicationRecord
  belongs_to :lesson, optional: true
  belongs_to :answer, optional: true
  belongs_to :word, optional: true
end
