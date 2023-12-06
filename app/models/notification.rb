class Notification < ApplicationRecord

  enum confirmed: { unconfirmed:0, confirmed: 1 }


end
