class Post < ApplicationRecord

  # タグ付け機能
  # acts_as_taggable_on :tags の省略
  acts_as_taggable
  # @post.skill_list などが使用可能になる
  acts_as_taggable_on :skills, :interests

  belongs_to :user, optional: true
  # prefectureモデルに従属するが、例外的に空欄を許可
  belongs_to :prefecture, optional: true

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum post_status: { publicized: 0, draft: 1 }

  validates :post_status, presence: true

  # 下書きの際は条件を満たしていなくても保存できるようにバリデーション設定
  with_options presence: true, on: :publicized do
    validates :content, length: { maximum: 400 }
    validates :image
    validates :tag_list
    validates :prefecture_id
  end

  # validates :content, presence: true
  #validate :image
  #validate :prefecture_id#, presence: true

  has_one_attached :image

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end


end
