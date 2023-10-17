FactoryBot.define do
  factory :user do
    user_name { "test" }
    sequence(:email) { |n| "test#{n}@example.com" }
    uid { SecureRandom.uuid }
    password { "testpassword" }
    phone_number { "00000000000" }
    birthdate { "2000-01-01" }
    
    trait :password_nil do
      password { nil }
    end

    trait :phone_number_nil do
      phone_number { nil }
    end
    
    trait :user_name_characters_50 do
      user_name { SecureRandom.alphanumeric(50) }
    end

    trait :user_name_characters_51 do
      user_name { SecureRandom.alphanumeric(51) }
    end
  end
end
