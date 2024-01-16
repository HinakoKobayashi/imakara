FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" } # 最小6文字の要件を満たす
    profile_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_profile_image.jpg'), 'image/jpeg') }
  end
end