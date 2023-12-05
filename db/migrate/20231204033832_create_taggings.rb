class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.string :taggable_type
      t.integer :taggable_id
      t.string :tagger_type
      t.integer :tagger_id
      t.string :content

      t.timestamps
    end
  end
end
