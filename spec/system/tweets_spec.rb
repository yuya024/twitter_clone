require 'rails_helper'

RSpec.describe "Tweets", type: :system do
  before do
    @user = FactoryBot.create(:user, :logined)
    sign_in @user
    visit home_path(@user.id)
  end

  scenario "user can create tweet" do
    content = "test"
    expect {
      fill_in "tweet_content", with: content
      click_button "ツイートする"
      expect(page).to have_content content
    }.to change(@user.tweets, :count).by(1)
  end

  scenario "user can't create tweet" do
    content = nil
    expect {
      fill_in "tweet_content", with: content
      click_button "ツイートする"
      expect(page).to have_content content
    }.to_not change(@user.tweets, :count)
  end
end
