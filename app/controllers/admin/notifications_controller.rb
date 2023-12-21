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
      @notification.mark_as_read
      redirect_to admin_notifications_path, notice: '通知を既読にしました'
    else
      redirect_to admin_notifications_path, alert: '通知はありません'
    end
  end

  # 全通知を既読にする
  def mark_all_as_read
    Notification.where(status: false).update_all(status: true)
    redirect_to admin_notifications_path, notice: '全ての通知を既読にしました'
  end
end
