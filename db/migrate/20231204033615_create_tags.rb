class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :tag_name
      t.integer :taggings_count

      t.timestamps
    end
  end
end
