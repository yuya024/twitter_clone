require 'rails_helper'

RSpec.describe "Users::Registrations", type: :system do
  scenario "user creates an account" do
    user = FactoryBot.build(:user)
    password = user.password

    visit root_path
    
    click_link "新規登録"
    fill_in "ユーザー名", with: user.user_name
    fill_in "Eメール", with: user.email
    fill_in "電話番号", with: user.phone_number
    fill_in "生年月日", with: user.birthdate
    fill_in "パスワード", with: user.password
    fill_in "パスワード（確認用）", with: user.password
    click_button "新規登録"
    expect(page).to have_text("本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。")
    
    user = User.find_by(email: user.email)
    user.confirm
    expect(user.confirmed?).to be true
    
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"

    expect(page).to have_content("ログインしました")
    expect(current_path).to eq home_path(user.id)
  end

  scenario "user can't create an account" do
    user = FactoryBot.build(:user)

    visit root_path
    
    click_link "新規登録"
    fill_in "ユーザー名", with: user.user_name
    fill_in "Eメール", with: user.email
    fill_in "電話番号", with: user.phone_number
    fill_in "生年月日", with: user.birthdate
    fill_in "パスワード", with: user.password
    fill_in "パスワード（確認用）", with: user.password
    click_button "新規登録"
    
    expect(current_path).to_not eq root_path
    expect(page).to_not have_text("本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。")
  end
end
