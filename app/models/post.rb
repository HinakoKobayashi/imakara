class Post < ApplicationRecord

  # タグ付け機能
  # acts_as_taggable_on :tags の省略
  acts_as_taggable
  # @post.skill_list などが使用可能になる
  acts_as_taggable_on :skills, :interests

  belongs_to :user
  belongs_to :prefecture

  #has_many :taggings, dependent: :destroy
  #has_many :base_tags, through: :taggings, source: :tag
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum post_status: { published: 0, draft: 1, unpublished: 2 }

  #validates :post_status, presence: true
  validates :prefecture_id, presence: true

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


end
