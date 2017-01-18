class Activity < ApplicationRecord
  belongs_to :user
  validates :action_type, presence: true

  enum action_type: {
    follow: 0,
    unfollow: 1,
    start_lesson: 2,
    finish_lesson: 3,
    destroy_lesson: 4,
    login: 5,
    logout: 6
  }

  scope :feed_activities, -> user_id {
    where "user_id in (select id from users
      where id = #{user_id} or id in (select followed_id from relationships
        where follower_id = #{user_id}))"}

  def enum_to_string
    I18n.t("activities.action_name.#{self.action_type}")
  end
end
