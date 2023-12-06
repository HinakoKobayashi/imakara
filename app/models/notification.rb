class Notification < ApplicationRecord

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  enum confirmed: { unconfirmed:0, confirmed: 1 }


end
