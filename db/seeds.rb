# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'open-uri'

DEFAULT_PHONE_NUMBER = '00000000000'
DEFAULT_INTRODUCTION = 'Happiness ChainでWebエンジニアになるために勉強中です。よろしくお願いします！'
DEFAULT_LOCATION = '東京 渋谷区'
DEFAULT_WEBSITE = 'default.com'
content = ['今日は暑い！', '今日は寒い！', '今日は涼しいな！', '今日は暖かいな！', "もくもく！\n今日も頑張ろう!"]
comment = 'そうですね〜'

my_account = User.find_or_initialize_by(email: 'main@example.com')
my_account.uid = SecureRandom.uuid
my_account.user_name = 'main'
my_account.password = 'mainpassword'
my_account.phone_number = DEFAULT_PHONE_NUMBER
my_account.birthdate = Time.zone.today
my_account.introduction = DEFAULT_INTRODUCTION
my_account.location = DEFAULT_LOCATION
my_account.website = DEFAULT_WEBSITE
my_account.skip_confirmation!
my_account.save!
my_account.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/nissy.jpg')), filename: 'nissy.jpg')
my_account.header_image.attach(io: File.open(Rails.root.join('app/assets/images/default_header.jpg')),
                               filename: 'default_header.jpg')
my_account.tweets.create!(content: content.sample)

# mainとフォロー関係にあるユーザ
ActiveRecord::Base.transaction do
  15.times do |n|
    user = User.find_or_initialize_by(email: "followee#{n + 1}@example.com")
    user.uid = SecureRandom.uuid
    user.user_name = "followee#{n + 1}"
    user.password = "followee#{n + 1}"
    user.phone_number = DEFAULT_PHONE_NUMBER
    user.birthdate = Time.zone.today
    user.introduction = DEFAULT_INTRODUCTION
    user.location = DEFAULT_LOCATION
    user.website = DEFAULT_WEBSITE
    user.skip_confirmation!
    user.save!
    user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/default_profile.jpg')),
                              filename: 'default_profile.jpg')
    user.header_image.attach(io: File.open(Rails.root.join('app/assets/images/default_header.jpg')),
                             filename: 'default_header.jpg')

    Follow.find_or_create_by!(follower_id: my_account.id, followee_id: user.id)
    Follow.find_or_create_by!(follower_id: user.id, followee_id: my_account.id)
    followee_tweet = user.tweets.create!(content: content.sample)
    followee = User.includes(:tweets).find_by!(email: 'main@example.com')
    user.favorites.find_or_create_by!(tweet_id: followee.tweets.first.id)
    user.retweets.find_or_create_by!(tweet_id: followee.tweets.first.id)
    user.comments.find_or_create_by!(content: comment, tweet_id: followee.tweets.first.id)

    my_account.favorites.find_or_create_by!(tweet_id: followee_tweet.id)
  end
end

# おすすめユーザ
ActiveRecord::Base.transaction do
  15.times do |n|
    user = User.find_or_initialize_by(email: "osusume#{n + 1}@example.com")
    user.uid = SecureRandom.uuid
    user.user_name = "osusume#{n + 1}"
    user.password = "osusume#{n + 1}"
    user.phone_number = DEFAULT_PHONE_NUMBER
    user.birthdate = Time.zone.today
    user.introduction = DEFAULT_INTRODUCTION
    user.location = DEFAULT_LOCATION
    user.website = DEFAULT_WEBSITE
    user.skip_confirmation!
    user.save!
    user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/default_profile.jpg')),
                              filename: 'default_profile.jpg')
    user.header_image.attach(io: File.open(Rails.root.join('app/assets/images/default_header.jpg')),
                             filename: 'default_header.jpg')

    recommend_tweet = user.tweets.create!(content: content.sample)
    followee = User.includes(:tweets).find_by!(email: 'main@example.com')
    user.favorites.find_or_create_by!(tweet_id: followee.tweets.first.id)
    user.retweets.find_or_create_by!(tweet_id: followee.tweets.first.id)
    user.comments.find_or_create_by!(content: comment, tweet_id: followee.tweets.first.id)

    my_account.favorites.find_or_create_by!(tweet_id: recommend_tweet.id)
  end
end
