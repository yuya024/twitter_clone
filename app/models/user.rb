# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, omniauth_providers: %i[github]

  validates :user_name, presence: true
  validates :phone_number, presence: true
  validates :birthdate, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  has_many :tweets, dependent: :destroy
  has_many :follower, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :followee, class_name: 'Follow', foreign_key: 'followee_id', dependent: :destroy, inverse_of: :followee
  has_many :following_user, through: :follower, source: :followee
  has_many :follower_user, through: :followee, source: :follower
  has_many :favorites, dependent: :destroy, class_name: 'Favorite'
  has_many :retweets, dependent: :destroy, class_name: 'Retweet'
  has_one_attached :profile_image
  has_one_attached :header_image

  DEFAULT_PHONE_NUMBER = '00000000000'
  DEFAULT_PASSWORD_LENGTH = 10

  def self.from_omniauth(auth)
    user = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user.user_name = auth.info.nickname
    user.email = auth.info.email
    user.password = Devise.friendly_token(DEFAULT_PASSWORD_LENGTH) if user.password.blank?
    user.password_confirmation = user.password if user.password.blank?
    user.phone_number = DEFAULT_PHONE_NUMBER unless user.phone_number?
    user.birthdate = Time.zone.today unless user.birthdate?
    # メール認証をスキップする
    user.skip_confirmation!
    user.save!
    user.default_image_setup
    user
  end

  def default_image_setup
    profile_image.attach(io: File.open(Rails.root.join('app/assets/images/default_profile.jpg')),
                         filename: 'default_profile.jpg')
    header_image.attach(io: File.open(Rails.root.join('app/assets/images/default_header.jpg')),
                        filename: 'default_header.jpg')
  end

  def profile_image_tag(size:)
    profile_image.variant(resize_to_fill: [size, size]).processed
  end
end
