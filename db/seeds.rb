# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  # Admin.create!(
  #   email: "admin@admin.com",
  #   password: "000000"
  # )

  15.times do |n|
    User.create!(
      name: "fes#{n + 1}",
      introduction: "fes#{n + 1}です。よろしくお願いします。",
      email: "fes#{n + 1}@fes.com",
      password: "000000",
      profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/no_image.jpg")), filename: "no_image.jpg")
      )
  end

 # Tag.create(tag_name: "開催日時")
 # Tag.create(tag_name: "周辺情報")
 # Tag.create(tag_name: "歴史")
 # Tag.create(tag_name: "見物スポット")

  # User.all.each do |user|
  #   rand(1..5).times do
  #     user.posts.create!(
  #       user_id: user.id,
  #       content: "#{rand(1..75)}〇〇祭り情報",
  #       prefecture_id: rand(1..48),
  #       post_status: [:published, :draft, :unpublished].sample,
  #       image: ActiveStorage::Blob.create_and_upload!(io: File.open(Rails.root.join("app/assets/images/no_image.jpg")), filename: "no_image.jpg")
  #       )
  #   end
  # end