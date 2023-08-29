# frozen_string_literal: true

class TweetsController < ApplicationController
  def create
    @tweet = current_user.tweets.new(tweet_params)
    if params[:tweet][:content].empty? && params[:tweet][:image].blank?
      @error_messages = ['文章か写真を投稿してください']
      set_followee_tweets
      render 'homes/show', status: :unprocessable_entity
    elsif (created_tweet = Tweet.create_tweet(user: current_user, params: tweet_params)).is_a?(Tweet)
      redirect_to home_path(current_user.id)
    else
      @error_messages = created_tweet
      set_followee_tweets
      render 'homes/show', status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content, :image)
  end

  def set_followee_tweets
    followee_ids = current_user.follower.pluck(:followee_id)
    user_ids = followee_ids.dup << current_user.id
    @tweets = Tweet.includes(:user, :favorites, :retweets,
                             :comments).where(user_id: user_ids).recent.page(params[:page])
  end
end
