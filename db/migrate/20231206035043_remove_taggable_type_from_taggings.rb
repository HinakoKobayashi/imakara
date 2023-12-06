class RemoveTaggableTypeFromTaggings < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :taggable_type, :string
  end
end
