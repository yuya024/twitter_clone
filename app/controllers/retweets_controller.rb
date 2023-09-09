# frozen_string_literal: true

class RetweetsController < ApplicationController
  def create
    current_user.retweets.create!(tweet_id: params[:tweet_id])
    flash[:notice] = 'リツイートしました'
    redirect_to home_path(current_user)
  end

  def destroy
    retweet = current_user.retweets.find_by!(tweet_id: params[:tweet_id])
    retweet.destroy!
    flash[:notice] = 'リツイート取り消しました'
    redirect_to home_path(current_user)
  end
end
