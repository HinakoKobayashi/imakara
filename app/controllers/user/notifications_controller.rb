class User::NotificationsController < ApplicationController
  before_action :authenticate_user!

  # 通知一覧
  def index
    # 現在ログインしているユーザーが受け取った未読の通知を全て取得
    @notifications = current_user.visited.unread.order(created_at: :desc)
    # リクエストのフォーマットに応じて異なるレスポンスを返す
    respond_to do |format|
      # ページの一部を動的に更新
      format.turbo_stream do
        render turbo_stream: [
          # 指定されたDOM('notifications'というIDを持つ)要素の中に新しい通知を追加
          turbo_stream.append('notifications', partial: 'notifications/notification',
                              collection: @notifications, as: :notification),
          # 'notification_count'というIDを持つ要素を、新しいコンテンツで置き換える
          turbo_stream.replace('notification_count', partial: 'notifications/notification_count',
                              locals: { notifications: @notifications })
        ]
      end
      # Webページ全体をロードまたは再ロード
      format.html
    end
  end

  # 未読を既読に更新
  def update
    @notification = current_user.visited_notifications.find_by(id: params[:id])
    if @notification.update(unread: false)
      respond_to do |format|
        format.turbo_stream do
          if @notification
            render turbo_stream: [
              # 更新された通知をDOMから削除
              turbo_stream.remove(@notification),
              # 通知の総数を表示するDOM要素を更新
              turbo_stream.replace('notification_count', partial: 'notifications/notification_count',
                                   locals: { notifications: current_user.received_notifications.unread })
            ]
          # 通知が見つからない場合に通知リストの表示をクリア
          else
            render turbo_stream: turbo_stream.replace('notifications', '')
          end
        end
        format.html
      end
    end
  end

  # 全通知を既読にする
  def mark_all_as_read
    @notifications = current_user.received_notifications.unread
    # 取得した全ての未読通知を既読（unread: false）に一括更新
    @notifications.update_all(unread: false)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          # 全ての通知が読み取り済みに更新された後に、通知リストをクリア
          turbo_stream.remove('notifications'),
          # 通知の総数を表示するDOM要素を更新
          turbo_stream.replace('notification_count', partial: 'notifications/notification_count',
                               locals: { notifications: current_user.received_notifications.unread }),
          # 全ての通知が読み取り済みになったことを示すメッセージを表示
          turbo_stream.prepend('no_notification', partial: 'notifications/no_notification')
        ]
      end
      format.html
    end
  end
end
