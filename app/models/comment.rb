class Comment < ApplicationRecord

  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

end
