class AddNotifiableIdToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :notifiable_id, :integer
  end
end
