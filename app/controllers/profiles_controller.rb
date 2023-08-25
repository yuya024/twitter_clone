# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :sigin_in_required, only: %i[show edit]

  def show
    tweets = Tweet.includes(:user, :favorites, :retweets, :comments)
    if params[:is_comment].present?
      tweets_by_comment(tweets)
    elsif params[:is_retweet].present?
      tweets_by_retweet(tweets)
    elsif params[:is_favorite].present?
      tweets_by_favorite(tweets)
    else
      @tweets = tweets.where(user_id: current_user.id).recent.page(params[:page])
      @is_tweet = true
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path(@user)
    else
      @error_messages = @user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def tweets_by_comment(tweets)
    comment_tweet_ids = current_user.comments.pluck(:tweet_id)
    @tweets = tweets.where(id: comment_tweet_ids).recent.page(params[:page])
    @is_comment = true
  end

  def tweets_by_retweet(tweets)
    retweet_tweet_ids = current_user.retweets.pluck(:tweet_id)
    @tweets = tweets.where(id: retweet_tweet_ids).recent.page(params[:page])
    @is_retweet = true
  end

  def tweets_by_favorite(tweets)
    favorite_tweet_ids = current_user.favorites.pluck(:tweet_id)
    @tweets = tweets.where(id: favorite_tweet_ids).recent.page(params[:page])
    @is_favorite = true
  end

  def user_params
    params.require(:user).permit(:user_name, :introduction, :location, :website, :birthdate, :profile_image,
                                 :header_image)
  end
end
