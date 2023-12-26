class ApplicationController < ActionController::Base
  before_action :set_unread_notifications
  helper_method :unread_user_notifications, :unread_admin_notifications

  private

  def set_unread_notifications
    @unread_notifications = if user_signed_in?
                              unread_user_notifications
                            elsif admin_signed_in?
                              unread_admin_notifications
                            else
                              []
                            end
  end

  def unread_user_notifications
    return [] unless user_signed_in?
    current_user.received_notifications.where(notifiable_type: ['Comment', 'Favorite'], status: false)
  end

  def unread_admin_notifications
    return [] unless admin_signed_in?
    Notification.where(notifiable_type: 'Request', status: false)
  end
end
