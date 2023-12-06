class Post < ApplicationRecord

  belongs_to :user
  belongs_to :prefecture

  has_many :taggings, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum post_status: { published: 0, draft: 1, unpublished: 2 }

  validates :post_status, presence: true

end
