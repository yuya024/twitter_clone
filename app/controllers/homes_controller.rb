# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :sigin_in_required, only: [:show]
  def index; end

  def show
    if params[:is_recommend].present?
      @tweets = Tweet.includes(:user).order(created_at: :desc).page(params[:page])
      @is_recommend = true
    else
      followees_id = current_user.follower.pluck(:followee_id)
      @tweets = Tweet.includes(:user).where(user_id: followees_id).order(created_at: :desc).page(params[:page])
    end
  end
end
