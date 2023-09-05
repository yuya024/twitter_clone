# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    redirect_to tweet_path(params[:tweet_id])
  end

  def create
    @comment = current_user.comments.new(comment_params)
    if params[:comment][:content].empty? && params[:comment][:image].blank?
      redirect_to tweet_path(params[:tweet_id]), status: :unprocessable_entity, alert: '文章か写真を投稿してください'
    elsif (created_comment = Comment.create_comment(user: current_user, params: comment_params,
                                                    tweet_id: params[:tweet_id])).is_a?(Comment)
      flash[:notice] = 'コメントを返信しました'
      redirect_to tweet_path(params[:tweet_id])
    else
      @error_messages = created_comment
      set_tweet_detail
      render 'tweets/show', status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :image).merge(tweet_id: params[:tweet_id])
  end

  def set_tweet_detail
    @tweet = Tweet.includes(:user, :favorites, :retweets, :comments).find(params[:tweet_id])
    @comments = Comment.includes(:user).where(tweet_id: params[:tweet_id]).recent.page(params[:page])
  end
end
