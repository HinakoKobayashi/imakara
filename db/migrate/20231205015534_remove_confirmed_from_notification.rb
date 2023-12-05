class RemoveConfirmedFromNotification < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :confirmed, :integer
  end
end
