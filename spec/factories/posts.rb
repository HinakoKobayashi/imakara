FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.paragraph }
    address { Faker::Address.full_address }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    post_status { [0, 1].sample } # 0と1からランダムに選ぶ例
    # prefecture_idについては、必要に応じて適切な値を設定してください。
  end
end