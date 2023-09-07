# frozen_string_literal: true

class FavoritesController < ApplicationController
  def create
    current_user.favorites.create!(tweet_id: params[:tweet_id])
    @tweet = Tweet.includes(:favorites).find(params[:tweet_id])
    render turbo_stream: turbo_stream.replace(@tweet, partial: 'homes/favorite', locals: { tweet: @tweet })
  end

  def destroy
    favorite = current_user.favorites.find_by!(tweet_id: params[:tweet_id])
    favorite.destroy!
    @tweet = Tweet.includes(:favorites).find(params[:tweet_id])
    render turbo_stream: turbo_stream.replace(@tweet, partial: 'homes/favorite', locals: { tweet: @tweet })
  end
end
