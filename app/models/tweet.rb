# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :favorites, class_name: 'Favorite', dependent: :destroy
  has_many :retweets, class_name: 'Retweet', dependent: :destroy
  has_many :replies, class_name: 'Tweet', foreign_key: 'reply_to', dependent: :destroy, inverse_of: :parent
  belongs_to :parent, class_name: 'Tweet', optional: true, foreign_key: 'reply_to', inverse_of: :replies
  delegate :user_name, to: :user, allow_nil: true
  scope :recent, -> { order(created_at: :desc) }
end
