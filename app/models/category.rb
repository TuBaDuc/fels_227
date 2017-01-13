class Category < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy

  mount_uploader :photo, PhotoUploader
  validates :name, presence: true, length: {maximum: 100},
    uniqueness: {case_sensitive: false}
  validates :description, presence: true, length: {maximum: 255}

  def self.search name
    name ? where("name LIKE ?", "%#{name}%") : all
  end
end
