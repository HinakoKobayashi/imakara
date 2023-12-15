class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 300 }

end
