# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  admin = Admin.find_or_initialize_by(
    email: "admin@admin.com",
  )
  if admin.new_record?
    admin.password = "000000"
    admin.save!
  end

  # Ruby のリテラル表現の一つ スペースで区切られた文字列の配列を簡潔に作成する
  prefectures = %w(
    北海道 青森県 岩手県 宮城県 秋田県 山形県 福島県
    茨城県 栃木県 群馬県 埼玉県 千葉県 東京都 神奈川県
    新潟県 富山県 石川県 福井県 山梨県 長野県
    岐阜県 静岡県 愛知県 三重県
    滋賀県 京都府 大阪府 兵庫県 奈良県 和歌山県
    鳥取県 島根県 岡山県 広島県 山口県
    徳島県 香川県 愛媛県 高知県
    福岡県 佐賀県 長崎県 熊本県 大分県 宮崎県 鹿児島県
    沖縄県 その他
  )

  prefectures.each do |prefecture|
    Prefecture.create!(name: prefecture)
  end

  # ActiveStorageの設定
  ActiveStorage::AnalyzeJob.queue_adapter = :inline
  ActiveStorage::PurgeJob.queue_adapter = :inline

  # タグのリストを定義
  tags = %w(夏祭り 花火 神輿 出店 初詣)

  tags.each do |tag_name|
    Tag.find_or_create_by(name: tag_name)
  end

  # タグのリストはseedファイルの外で定義し、acts_as_taggable_onの機能を使用

  5.times do |n|
    name = "FES太郎#{n + 1}号"
    email = "fes#{n + 1}@fes.com"

    user = User.find_or_create_by!(name: name, email: email) do |u|
    u.introduction = "fes#{n + 1}です。よろしくお願いします。"
    u.password = "000000"
    # 画像は後で関連付ける
    end

    post = user.posts.create!(content: "#{n + 1}〇〇祭りに来ています", prefecture_id: rand(1..48))

    # ActsAsTaggableOnを使用してタグを追加
    tag_list = %w(夏祭り 花火 神輿 出店 初詣).sample(rand(1..3)).join(', ')
    post.tag_list = tag_list
    post.save!

    # プロファイル画像を関連付ける
    unless user.profile_image.attached?
      user.profile_image.attach(io: File.open(Rails.root.join("app/assets/images/no_image.jpg")), filename: "no_image.jpg")
    end
  end