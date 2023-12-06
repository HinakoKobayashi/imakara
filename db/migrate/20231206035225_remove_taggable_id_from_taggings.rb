class RemoveTaggableIdFromTaggings < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :taggable_id, :integer
  end
end
