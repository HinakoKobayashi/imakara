class RemoveCheckedFromRequest < ActiveRecord::Migration[6.1]
  def change
    remove_column :requests, :checked, :integer
  end
end
