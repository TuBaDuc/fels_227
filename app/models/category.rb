class Category < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  validates :name, presence: true, length: {maximum: 100},
    uniqueness: {case_sensitive: false}
  validates :description, presence: true, length: {maximum: 255}
end
