# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :sigin_in_required, only: [:show]
  def index; end

  def show
    if params[:osusume].present?
      @users_tweets = Tweet.includes(:user).order(created_at: :desc).page(params[:page])
      @osusume = true
    else
      followees_id = current_user.follows.pluck(:followee_id)
      @users_tweets = Tweet.includes(:user).where(user_id: followees_id).order(created_at: :desc).page(params[:page])
    end
  end
end
