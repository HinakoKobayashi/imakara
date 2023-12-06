class RemoveCheckedFromNotification < ActiveRecord::Migration[6.1]
  def change
    remove_column :notifications, :checked, :integer
  end
end
