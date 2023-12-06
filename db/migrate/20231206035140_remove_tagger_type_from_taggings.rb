class RemoveTaggerTypeFromTaggings < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :tagger_type, :string
  end
end
