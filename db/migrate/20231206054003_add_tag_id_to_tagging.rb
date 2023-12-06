class AddTagIdToTagging < ActiveRecord::Migration[6.1]
  def change
    add_column :taggings, :tag_id, :integer
  end
end
