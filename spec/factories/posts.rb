require 'faker'
FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.paragraph }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_image.jpg'), 'image/jpeg') }
    tag_list { ['tag1', 'tag2'] }
    prefecture_id { rand(1..48) }
    post_status { :publicized }
  end
end
