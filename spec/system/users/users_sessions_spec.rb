require 'rails_helper'

RSpec.describe "Users::Sessions", type: :system do
  scenario "user can log in" do
    user = FactoryBot.create(:user)
    user.default_image_setup
    user.confirm

    visit root_path
    click_link "ログイン"
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    sleep(1)
    
    expect(current_path).to eq home_path(user.id)
    expect(page).to have_content("ログインしました")
  end

  scenario "user can't log in" do
    user = FactoryBot.create(:user)
    user.default_image_setup
    user.confirm

    visit root_path
    click_link "ログイン"
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "wrong pass"
    click_button "ログイン"
    sleep(1)
    
    expect(current_path).to_not eq home_path(user.id)
    expect(page).to have_content("Eメールまたはパスワードが違います。")
  end
end
