class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: {scope: :post_id}

end
