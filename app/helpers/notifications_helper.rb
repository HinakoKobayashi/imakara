module NotificationsHelper
  # 通知の詳細をレンダリングするヘルパーメソッド
  def render_notification(notification)
    # sender を User オブジェクトとして取得
    user = User.find_by(name: notification.sender) || User.find_by(id: notification.sender)

    # 管理者専用の通知表示
    if notification.admin_specific?
      case notification.notifiable_type
      when 'Request'
        if user
          link_to(user.name, admin_user_path(user), class: "notification-link") + "からのリクエスト\n\n タイトル: #{notification.notifiable.title} \n 本文: #{notification.notifiable.body}"
        else
          # \n で改行、\n\n で1行空ける
          "未知のユーザーからのリクエスト\n\n タイトル: #{notification.notifiable.title} \n 本文: #{notification.notifiable.body}"
        end
      else
        "新しい通知があります"
      end
    # 一般ユーザー向け通知表示
    else
      case notification.notifiable_type
      when 'Comment'
        if user
          link_to(user.name, user_path(user)) + "がコメントしました: \n\n #{notification.notifiable.comment}"
        else
          "未知のユーザーがコメントしました: #{notification.notifiable.comment}"
        end
      when 'Favorite'
        if user
          link_to(user.name, user_path(user)) + "があなたの投稿をいいねしました"
        else
          "未知のユーザーがあなたの投稿をいいねしました"
        end
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
      if notification.notifiable.respond_to?(:post) && notification.notifiable.post
        content = notification.notifiable.post.content
        # 表示する文字数を指定
        content.truncate(100)
      else
      # 関連する Post が存在しない場合の処理
      '関連する投稿が見つかりません。'
      end
    else
      ''
    end
  end
end
