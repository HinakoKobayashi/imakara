class Request < ApplicationRecord

  belongs_to :user

  has_many :notifications, as: :notifiable, dependent: :destroy

  enum confirmed: { unconfirmed:0, confirmed: 1 }

  validates :confirmed, presence: true

end
