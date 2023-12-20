class Notification < ApplicationRecord

  belongs_to :sender, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'visited_id'
  belongs_to :notifiable, polymorphic: true

  enum confirmed: { unread: 0, read: 1 }

end
