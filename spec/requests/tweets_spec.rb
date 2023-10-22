# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :request do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    @user.default_image_setup
  end

  it "create a tweet" do
    tweet_params = { tweet: { content: "test"}}
    sign_in @user
    expect {
      post tweets_path, params: tweet_params
    }.to change(@user.tweets, :count).by(1)
  end

  it "can't create a tweet without no images and empty text" do
    tweet_params = { tweet: { content: ""}}
    sign_in @user
    expect {
      post tweets_path, params: tweet_params
    }.to_not change(@user.tweets, :count)
  end
end
