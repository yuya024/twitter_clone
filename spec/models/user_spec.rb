# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a user name, email, uid, password, phone number, birthdate" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  it "is invalid without a password" do
    user = FactoryBot.build(:user, :password_nil)
    user.valid?
    expect(user.errors.full_messages).to include("パスワードを入力してください")
  end

  it "is invalid without a phone numer" do
    user = FactoryBot.build(:user, :phone_number_nil)
    user.valid?
    expect(user.errors.full_messages).to include("電話番号を入力してください")
  end

  it "is valid if user name is less than 50 characters" do
    expect(FactoryBot.build(:user, :user_name_characters_50)).to be_valid
  end

  it "is invalid if user name is longer than 51 characters" do
    user = FactoryBot.build(:user, :user_name_characters_51)
    user.valid?
    expect(user.errors.full_messages).to include("ユーザー名は50文字以内で入力してください")
  end
end
