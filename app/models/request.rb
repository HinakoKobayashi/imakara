class Request < ApplicationRecord

  #barideなしリレーションかける
  belongs_to :user, optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  #enum confirmed: { unconfirmed:0, confirmed: 1 }

  #validates :confirmed, presence: true

  after_create_commit :create_request_notification

  private

  def create_request_notification
    admin_user_id = AdminUser.first.id

    Notification.create(
      visitor_id: self.user_id,
      visited_id: admin_user_id,
      notifiable: self
    )
  end

end
