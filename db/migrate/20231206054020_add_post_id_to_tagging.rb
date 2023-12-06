class AddPostIdToTagging < ActiveRecord::Migration[6.1]
  def change
    add_column :taggings, :post_id, :integer
  end
end
