class User::NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 通知一覧
  def index
    # 現在ログインしているユーザーが受け取った未読の通知を全て取得
    @notifications = current_user.received_notifications.unread.order(created_at: :desc)
  end

  # 未読を既読に更新
  def update
    # パラメーターとして渡されたIDに基づいて、ユーザーが受け取った通知の中から特定の通知を検索
    @notification = current_user.received_notifications.find_by(id: params[:id])
    # 検索した通知が実際に存在するかどうかをチェック
    if @notification
      # 通知が存在する場合にその状態を「既読」に更新
      @notification.read!
      redirect_to notifications_path, notice: 'Notification marked as read.'
    # 通知が見つからない場合に通知リストの表示をクリア
    else
      redirect_to notifications_path, alert: 'Notification not found.'
    end
  end

  # 全通知を既読にする
  def mark_all_as_read
    @notifications = current_user.received_notifications.unread
    # 取得した全ての未読通知を既読（unread: false）に一括更新
    @notifications.update_all(unread: false)
  end
end
