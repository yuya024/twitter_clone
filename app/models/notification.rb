# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true
  enum action_type: {
    favorited_the_tweet: 0,
    retweeted_the_tweet: 1,
    commented_the_tweet: 2
  }
end
