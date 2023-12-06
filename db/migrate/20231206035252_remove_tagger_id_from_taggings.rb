class RemoveTaggerIdFromTaggings < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :tagger_id, :integer
  end
end
