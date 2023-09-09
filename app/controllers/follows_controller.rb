# frozen_string_literal: true

class FollowsController < ApplicationController
  def create
    current_user.follower.create!(followee_id: params[:followee_id])
    flash[:notice] = 'フォローしました'
    redirect_to tweet_path(params[:tweet_id])
  end
end
