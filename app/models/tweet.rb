# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :favorites, class_name: 'Favorite', dependent: :destroy
  has_many :retweets, class_name: 'Retweet', dependent: :destroy
  has_many :comments, dependent: :destroy
  delegate :user_name, to: :user, allow_nil: true
  scope :recent, -> { order(created_at: :desc) }
end
