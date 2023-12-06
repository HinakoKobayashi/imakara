class Post < ApplicationRecord

  belongs_to :user
  belongs_to :prefecture

  has_many :taggings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum post_status: { published: 0, draft: 1, unpublished: 2 }

  validates :post_status, presence: true

  has_many_attached :image
  def get_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/sample-author1.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [100, 100]).processed
  end

end
