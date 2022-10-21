FactoryBot.define do
  factory :user do
    name { 'aki' }
    email { 'aki@ex.com' }
    password { 'password' }
    password_confirmation { 'password' }
    admin { false }
  end
end
