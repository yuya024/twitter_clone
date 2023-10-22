require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  it "can Log in" do
    user = FactoryBot.create(:user)
    user.confirm
    # 恐らくメール認証をスキップしたことで画像の処理がされていないため
    user.default_image_setup

    sign_in user
    get home_path(user)
    expect(response).to have_http_status(200)
  end

  it "can't Log in without password" do
    user_attributes = User.new(email: "sample@example.com")

    post user_session_path, params: {
      user: user_attributes
    }
    expect(response).to_not have_http_status(200)
  end
end
