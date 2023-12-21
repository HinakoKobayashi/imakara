class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: {scope: :post_id}

  after_create_commit :create_favorite_notification

  private

  def create_favorite_notification
    # 自分自身の投稿への「いいね！」でなければ通知を生成
    return if self.user_id == self.post.user_id

    Notification.create!(
      visitor_id: self.user_id,
      visited_id: self.post.user_id,
      notifiable: self
    )
  end

end
