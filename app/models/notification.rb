class Notification < ApplicationRecord

  enum confirmed: { unconfirmed:0, confirmed: 1 }

  validates :confirmed, presence: true

end
