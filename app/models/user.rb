class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_many :activities, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :reset_token
  before_save   :downcase_email
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  VALID_PHONE_REGEX = /\d[0-9]\)*\z/i
  validates :phone, presence: true, length: {maximum: 16},
    format: {with: VALID_PHONE_REGEX}
  validates :address, presence: true, length: {maximum: 255}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated?attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
    update_attribute :reset_sent_at, Time.zone.now
  end

  def self.search name
    if name
      where("lower(name) LIKE ?", "%#{name.downcase}%")
    else
      all
    end
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include?other_user
  end

  def activity_info
    "#{self.name},#{user_path self}"
  end

  private
  def downcase_email
    self.email = email.downcase
  end
end
