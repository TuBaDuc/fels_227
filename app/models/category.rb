class Category < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :lessons, dependent: :destroy
  has_many :words, dependent: :destroy

  mount_uploader :photo, PhotoUploader
  validates :name, presence: true, length: {maximum: 100},
    uniqueness: {case_sensitive: false}
  validates :description, presence: true, length: {maximum: 255}

  scope :group_by_month, -> start_month, end_month do
    where("date_trunc('month', created_at) <= '#{end_month}' AND
      date_trunc('month', created_at) >= '#{start_month}'")
    .group("to_char(created_at, 'YYYY-MM')")
    .order("to_char_created_at_yyyy_mm ASC")
  end

  def self.search name
    name ? where("lower(name) LIKE ?", "%#{name.downcase}%") : all
  end

  def activity_info
    "#{self.name},#{category_path self}"
  end
end
