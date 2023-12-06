class AddPrefectureIdToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :prefecture_id, :integer, default:
  end
end
