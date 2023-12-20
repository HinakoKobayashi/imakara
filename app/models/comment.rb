class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, presence: true, length: { maximum: 300 }

  after_create_commit :create_notification_comment

  private

  def create_notification_comment
    # 自分自身の投稿へのコメントでなければ通知を生成
    return if self.user_id == self.post.user_id

    Notification.create!(
      visitor_id: self.user_id,
      visited_id: self.post.user_id,
      notifiable: self
    )
  end

end
