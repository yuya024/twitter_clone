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
  has_many :follows, dependent: :destroy
  has_one_attached :profile_image

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
    user
  end
end
