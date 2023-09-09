# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  has_many :favorites, class_name: 'Favorite', dependent: :destroy
  has_many :retweets, class_name: 'Retweet', dependent: :destroy
  has_many :comments, dependent: :destroy
  delegate :user_name, to: :user, allow_nil: true
  scope :recent, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :content, presence: true, length: { maximum: 140 }, unless: -> { image.attached? }
  validates :content, length: { maximum: 140 }, if: :image_and_content?

  def self.tweets_with_retweets
    tweet = Tweet.joins('LEFT OUTER JOIN retweets on tweets.id = retweets.tweet_id')
                 .select("tweets.*, retweets.user_id AS retweet_user_id,
                        (SELECT user_name FROM users WHERE id = retweets.user_id) AS retweets_user_name")
    tweet.where("NOT EXISTS(SELECT 1 FROM retweets sub
                WHERE retweets.tweet_id = sub.tweet_id AND retweets.created_at < sub.created_at)")
         .preload(:user, :comments, :retweets, :favorites)
         .order(Arel.sql('COALESCE(retweets.created_at, tweets.created_at) desc'))
  end

  def self.create_tweet(user:, params:)
    tweet = user.tweets.new(params)
    tweet.save ? tweet : tweet.errors.full_messages
  end

  def image_and_content?
    image.attached? && content.present?
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def retweeted_by?(user)
    retweets.where(user_id: user.id).exists?
  end
end
