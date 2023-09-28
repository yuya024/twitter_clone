# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_one :notification, as: :subject, dependent: :destroy
  delegate :user_name, to: :user, allow_nil: true
  scope :recent, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :content, presence: true, length: { maximum: 140 }, unless: -> { image.attached? }
  validates :content, length: { maximum: 140 }, if: :image_and_content?
  after_create_commit :create_notification

  def self.create_comment(user:, params:, tweet_id:)
    comment = user.comments.new(params)
    comment.tweet_id = tweet_id
    comment.save ? comment : comment.errors.full_messages
  end

  def image_and_content?
    image.attached? && content.present?
  end

  private

  def create_notification
    @notification = Notification.create!(subject: self, user_id: tweet.user.id,
                                         action_type: Notification.action_types[:commented_the_tweet])
    @user = User.find(tweet.user.id)
    NotificationMailer.notification_email(notification: @notification, user: @user).deliver_now
  end
end
