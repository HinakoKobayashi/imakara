FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    introduction { Faker::Lorem.sentence }
    password { "password" }
    is_active { true }
    guest { false }
  end
end