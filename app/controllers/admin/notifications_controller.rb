class Admin::NotificationsController < ApplicationController
  before_action :authenticate_admin!
  helper :notifications

  # 通知一覧
  def index
    # リクエストに関する通知のみを取得
    @notifications = Notification.where(notifiable_type: 'Request').order(created_at: :desc)
  end

  # 通知を既読に更新
  def update
    @notification = Notification.find_by(id: params[:id], notifiable_type: 'Request')
    if @notification
      @notification.read!
      redirect_to admin_notifications_path, notice: '通知を既読にしました'
    else
      redirect_to admin_notifications_path, alert: '通知はありません'
    end
  end

  # 全通知を既読にする
  def mark_all_as_read
    # 大量の通知を一度に既読にする際のパフォーマンスを考慮したバッチ処理
    Notification.where(notifiable_type: 'Request', status: false).find_each(batch_size: 100) do |notification|
    notification.update(status: true)
    end
    redirect_to admin_notifications_path, notice: '全ての通知を既読にしました'
  end
end
