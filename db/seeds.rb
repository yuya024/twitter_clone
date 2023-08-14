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
content = ['今日は暑い！', '今日は寒い！', '今日は涼しいな！', '今日は暖かいな！', "もくもく！\n今日も頑張ろう!"]

my_account = User.find_or_initialize_by(email: 'main@example.com')
my_account.uid = SecureRandom.uuid
my_account.user_name = 'main'
my_account.password = 'mainpassword'
my_account.phone_number = DEFAULT_PHONE_NUMBER
my_account.birthdate = Time.zone.today
my_account.skip_confirmation!
my_account.save!
unless my_account.profile_image.attached?
  if Rails.env.development?
    my_account.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/nissy.jpg')),
                                    filename: 'nissy.jpg')
  else
    image_data = URI.open('https://heroku-rails-twitter-clone.s3.amazonaws.com/nissy.jpg').read
    my_account.profile_image.attach(io: StringIO.new(image_data), filename: 'nissy.jpg')
  end
end

# mainとフォロー関係にあるユーザ
ActiveRecord::Base.transaction do
  15.times do |n|
    user = User.find_or_initialize_by(email: "followee#{n + 1}@example.com")
    user.uid = SecureRandom.uuid
    user.user_name = "followee#{n + 1}"
    user.password = "followee#{n + 1}"
    user.phone_number = DEFAULT_PHONE_NUMBER
    user.birthdate = Time.zone.today
    user.skip_confirmation!
    user.save!
    unless user.profile_image.attached?
      if Rails.env.development?
        user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/default_profile.jpg')),
                                  filename: 'default_profile.jpg')
      else
        image_data = URI.open('https://heroku-rails-twitter-clone.s3.amazonaws.com/default_profile.jpg').read
        user.profile_image.attach(io: StringIO.new(image_data), filename: 'default_profile.jpg')
      end
    end

    Follow.find_or_create_by!(user_id: my_account.id, followee_id: user.id)
    Follow.find_or_create_by!(user_id: user.id, followee_id: my_account.id)
    user.tweets.create!(content: content.sample)
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
    user.skip_confirmation!
    user.save!
    unless user.profile_image.attached?
      if Rails.env.development?
        user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/default_profile.jpg')),
                                  filename: 'default_profile.jpg')
      else
        image_data = URI.open('https://heroku-rails-twitter-clone.s3.amazonaws.com/default_profile.jpg').read
        user.profile_image.attach(io: StringIO.new(image_data), filename: 'default_profile.jpg')
      end
    end

    user.tweets.create!(content: content.sample)
  end
end
