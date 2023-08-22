# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :sigin_in_required, only: %i[show edit]

  def show
    tweets = Tweet.includes(:user, :favorites, :retweets, :replies)
    if params[:is_comment].present?
      tweets_by_comment(tweets)
    elsif params[:is_retweet].present?
      tweets_by_retweet(tweets)
    elsif params[:is_favorite].present?
      tweets_by_favorite(tweets)
    else
      @tweets = tweets.where(user_id: current_user.id, reply_to: nil).recent.page(params[:page])
      @is_tweet = true
    end
  end

  def edit; end

  private

  def tweets_by_comment(tweets)
    reply_tweet_ids = Tweet.where(user_id: current_user.id).where.not(reply_to: nil).pluck(:reply_to)
    @tweets = tweets.where(id: reply_tweet_ids).recent.page(params[:page])
    @is_comment = true
  end

  def tweets_by_retweet(tweets)
    retweet_tweet_ids = Retweet.where(user_id: current_user.id).pluck(:tweet_id)
    @tweets = tweets.where(id: retweet_tweet_ids, reply_to: nil).recent.page(params[:page])
    @is_retweet = true
  end

  def tweets_by_favorite(tweets)
    favorite_tweet_ids = Favorite.where(user_id: current_user.id).pluck(:tweet_id)
    @tweets = tweets.where(id: favorite_tweet_ids, reply_to: nil).recent.page(params[:page])
    @is_favorite = true
  end
end
