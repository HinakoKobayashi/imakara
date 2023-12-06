class RemoveContentFromTaggings < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :content, :string
  end
end
