class Request < ApplicationRecord
  
  #barideなしリレーションかける
  belongs_to :user, optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  #enum confirmed: { unconfirmed:0, confirmed: 1 }

  #validates :confirmed, presence: true

end
