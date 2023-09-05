# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  delegate :user_name, to: :user, allow_nil: true
  scope :recent, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :content, presence: true, length: { maximum: 140 }, unless: -> { image.attached? }
  validates :content, length: { maximum: 140 }, if: :image_and_content?

  def self.create_comment(user:, params:, tweet_id:)
    comment = user.comments.new(params)
    comment.tweet_id = tweet_id
    comment.save ? comment : comment.errors.full_messages
  end

  def image_and_content?
    image.attached? && content.present?
  end
end
