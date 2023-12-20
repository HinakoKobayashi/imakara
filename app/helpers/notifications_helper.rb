module NotificationsHelper
  # 通知メッセージを生成
  def generate_notification_message(notification)
    # notification が nil の場合、デフォルトの通知メッセージを返す
    return I18n.t('notifications.default_message') unless notification
    
    # 通知を送ったユーザーの名前を取得
    sender_name = notification.sender.user_name
    # 通知の種類を小文字に変換
    notifiable_type = notification.notifiable_type.downcase
    # 後述のメソッドを使用して通知対象の名前を取得
    notifiable_name = get_notifiable_name(notification)
    # ローカライズされた通知メッセージを生成し、sender と notifiable_name を置換
    I18n.t("notifications.message.#{notifiable_type}", sender: sender_name, notifiable_name: notifiable_name)
  end
  
  # 通知に関連する Post の画像URLを取得
  def get_notifiable_image_url(notification, width, height)
    return unless notification && notification.notifiable

    image = notification.notifiable.get_image(width, height)
    return nil unless image.present?

    Rails.application.routes.url_helpers.rails_representation_url(image, only_path: true)
  end

  private

  # 通知の種類に応じて適切な対象名(コメントやタイトルなど）を取得
  def get_notifiable_name(notification)
    return unless notification && notification.notifiable

    case notification.notifiable_type
    when 'Comment', 'Favorite'
    # Comment または Favorite の場合、関連する Post の content の先頭から一定文字数を表示
    content_preview(notification.notifiable.content)
    when 'Request'
    # Request の場合、title をそのまま表示
    notification.notifiable.title
    else
      I18n.t('notifications.default_notifiable_name')
    end
  end
  
  # 本文のプレビューを生成（最初の50文字）
  def content_preview(content)
    sanitize(content.truncate(50))
  end

  # XSS(クロスサイトスクリプティング)攻撃を防ぐためにサニタイズ(無害化)
  def sanitize(text)
    ActionController::Base.helpers.sanitize(text)
  end

end
