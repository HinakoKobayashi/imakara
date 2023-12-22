class User::NotificationsController < ApplicationController
  before_action :authenticate_user!
  helper :notifications

  # 通知一覧
  def index
    # ユーザーが受け取ったComment と Favorite に関する通知を全て取得
    @notifications = current_user.received_notifications
                                 .where(notifiable_type: ['Comment', 'Favorite'])
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(10)
  end

  # 未読を既読に更新
  def update
    # パラメーターとして渡されたIDに基づいて、ユーザーが受け取った通知の中から特定の通知を検索
    @notification = current_user.received_notifications.find_by(id: params[:id])
    # 検索した通知が実際に存在するかどうかをチェック
    if @notification
      # 通知が存在する場合にその状態を「既読」に更新
      @notification.mark_as_read
      redirect_to notifications_path, notice: '通知を既読にしました'
    # 通知が見つからない場合に通知リストの表示をクリア
    else
      redirect_to notifications_path, alert: '通知はありません'
    end
  end

  # 全通知を既読にする
  def mark_all_as_read
    current_user.received_notifications.where(status: false).update_all(status: true)
    redirect_to notifications_path, notice: '全ての通知を既読にしました'
  end
end
