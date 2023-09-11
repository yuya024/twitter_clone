# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :sigin_in_required, only: %i[show edit]

  def show
    tweets = Tweet.includes(:user, :favorites, :retweets, :comments, :bookmarks)
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
    @is_profile_view = true
  end

  def edit
    @user = current_user
  end

  def update
    if update_profile
      update_profile_image
      redirect_to profile_path(current_user)
    else
      @user = User.new(user_params)
      @error_messages = current_user.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def update_profile
    current_user.update(user_name: params[:user][:user_name],
                        introduction: params[:user][:introduction],
                        location: params[:user][:location],
                        website: params[:user][:website],
                        birthdate: params[:user][:birthdate])
  end

  # validationエラーに引っかかった際に、ActiveStorage::FileNotFoundErrorを回避するために画像だけ更新を分ける
  def update_profile_image
    current_user.profile_image.attach(params[:user][:profile_image]) if params[:user][:profile_image].present?
    current_user.header_image.attach(params[:user][:header_image]) if params[:user][:header_image].present?
  end

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
