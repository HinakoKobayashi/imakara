require 'faker'
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "password123" }
    profile_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/animal_mark_hiyoko.png'), 'image/png') }
  factory :tag, class: 'ActsAsTaggableOn::Tag' do
    name { "タグ名" }
  end
 end
end