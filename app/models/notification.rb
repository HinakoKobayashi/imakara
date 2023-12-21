class Notification < ApplicationRecord

  belongs_to :sender, class_name: 'User', foreign_key: 'visitor_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'visited_id'
  belongs_to :notifiable, polymorphic: true

  def admin_specific?
    # Requestタイプの通知を管理者専用とする
    self.notifiable_type == 'Request'
  end

  # 通知を既読にするメソッド
  def mark_as_read
    update(status: true)
  end

  # 通知が未読かどうかを確認するメソッド
  def unread?
    !status
  end

end
