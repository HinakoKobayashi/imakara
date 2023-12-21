module NotificationsHelper
  # 通知の詳細をレンダリングするヘルパーメソッド
  def render_notification(notification)
    sender = notification.sender.name
    # 管理者専用の通知表示
    if notification.admin_specific?
      case notification.notifiable_type
      when 'Request'
        "新しいリクエストが届きました: #{notification.notifiable.title}"
      else
        "新しい通知があります"
      end
    # 一般ユーザー向け通知表示
    else
      case notification.notifiable_type
      when 'Comment'
        "#{sender}がコメントしました: #{notification.notifiable.comment}"
      when 'Favorite'
        "#{sender}があなたの投稿をいいねしました"
      else
        "新しい通知があります"
      end
    end
  end

  # 通知に関連する投稿の画像URLを取得するヘルパーメソッド
  def notification_image_url(notification)
    # 対応するPostオブジェクトを取得
    post = case notification.notifiable_type
           when 'Favorite', 'Comment'
             notification.notifiable.post
           when 'Post'
             notification.notifiable
           else
             return nil
           end

    # Postの画像が添付されている場合にURLを生成
    if post&.image&.attached?
      url_for(post.image)
    end
  end

  # 通知に関連する本文のプレビューを取得するヘルパーメソッド
  def notification_content_preview(notification)
    return '' unless notification.notifiable

    case notification.notifiable_type
    when 'Comment', 'Favorite'
      content = notification.notifiable.post.content
      # 表示する文字数を指定
      content.truncate(100)
    else
      ''
    end
  end
end
