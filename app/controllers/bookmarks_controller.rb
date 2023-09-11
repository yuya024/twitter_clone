# frozen_string_literal: true

class BookmarksController < ApplicationController
  before_action :sigin_in_required, only: %i[index create destroy]

  def index
    @tweets = Tweet.joins(:bookmarks).includes(:user, :comments, :retweets, :favorites, :bookmarks)
                   .where(id: Bookmark.where(user_id: current_user.id).pluck(:tweet_id))
                   .order('bookmarks.created_at desc').page(params[:page])
  end

  def create
    current_user.bookmarks.create!(tweet_id: params[:tweet_id])
    @tweet = Tweet.find(params[:tweet_id])
    render turbo_stream: turbo_stream.replace("tweets_#{@tweet.id}_bookmark", partial: 'homes/bookmark',
                                                                              locals: { tweet: @tweet })
  end

  def destroy
    bookmark = current_user.bookmarks.find_by!(tweet_id: params[:tweet_id])
    bookmark.destroy!
    @tweet = Tweet.find(params[:tweet_id])
    render turbo_stream: turbo_stream.replace("tweets_#{@tweet.id}_bookmark", partial: 'homes/bookmark',
                                                                              locals: { tweet: @tweet })
  end
end
