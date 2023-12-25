class Request < ApplicationRecord

  #barideなしリレーションかける
  belongs_to :user, optional: true

  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create_commit :create_request_notification

  validates :title, presence: true
  validates :body, presence: true

  private

  def create_request_notification
    admin_user = Admin.find_by(email: 'admin@admin.com') # 管理者のメールアドレス

    Notification.create!(
      visitor_id: self.user_id,
      visited_id: admin_user.id,
      notifiable: self
    )
  end

end
