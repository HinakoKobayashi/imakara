class RenameActionColumnToNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :action, :notifiable_type
  end
end
