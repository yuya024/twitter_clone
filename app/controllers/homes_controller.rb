# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :sigin_in_required, only: [:show]
  def index; end

  def show
    if params[:is_recommend].present?
      @tweets = Tweet.includes(:user, :favorites, :retweets, :comments).recent.page(params[:page])
      @is_recommend = true
    else
      followee_ids = current_user.follower.pluck(:followee_id)
      user_ids = followee_ids.dup << current_user.id
      @tweets = Tweet.includes(:user, :favorites, :retweets,
                               :comments).where(user_id: user_ids).recent.page(params[:page])
    end
    @tweet = current_user.tweets.new
  end
end
