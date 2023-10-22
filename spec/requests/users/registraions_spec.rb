require 'rails_helper'

RSpec.describe "Users::Registraions", type: :request do
  it "register a new user" do
    user_attributes = FactoryBot.attributes_for(:user)
    
    expect {
      post user_registration_path, params: { 
        user: user_attributes
      }
    }.to change(User, :count).by(1)
  end

  it "can't register a new user" do
    user_attributes = FactoryBot.attributes_for(:user, :password_nil)
    
    expect {
      post user_registration_path, params: { 
        user: user_attributes
      }
    }.to_not change(User, :count)
  end
end
