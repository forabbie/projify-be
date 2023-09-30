FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "John#{n}" }
    sequence(:last_name) { |n| "Doe#{n}" }
    email { Faker::Name.unique.first_name.downcase + "@auth.com" }
    password { "password" }
    jti { Faker::Internet.device_token }
  end
end