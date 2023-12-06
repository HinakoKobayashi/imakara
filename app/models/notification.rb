class Notification < ApplicationRecord

  belongs_to :user
  belongs_to :comment
  belongs_to :favotrite
  belongs_to :request

  enum confirmed: { unconfirmed:0, confirmed: 1 }


end
