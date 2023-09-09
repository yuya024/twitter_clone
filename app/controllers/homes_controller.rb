# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :sigin_in_required, only: [:show]
  def index; end

  def show
    if params[:is_recommend].present?
      @tweets = Tweet.tweets_with_retweets.page(params[:page])
      @is_recommend = true
    else
      followee_ids = current_user.follower.pluck(:followee_id)
      followee_ids_with_userself = followee_ids.dup << current_user.id
      @tweets = current_user.following_tweets_with_retweets(followee_ids_with_userself: followee_ids_with_userself)
                            .page(params[:page])
    end
    @tweet = current_user.tweets.new
  end
end
