FactoryBot.define do
  factory :user do
    name { "user" }
    sequence(:email) { |n| "user#{n}@user.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end
end
