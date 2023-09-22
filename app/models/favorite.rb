# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_one :notification, as: :subject, dependent: :destroy
  validates :user_id, uniqueness: { scope: :tweet_id }
  after_create_commit :create_notification
  delegate :user_name, to: :user, allow_nil: true

  private

  def create_notification
    @notification = Notification.create!(subject: self, user_id: tweet.user.id,
                                         action_type: Notification.action_types[:favorited_the_tweet])
    @user = User.find(tweet.user.id)
    NotificationMailer.notification_email(notification: @notification, user: @user).deliver_now
  end
end
