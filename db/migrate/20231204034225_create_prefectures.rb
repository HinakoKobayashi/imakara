class CreatePrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.integer :prefecture

      t.timestamps
    end
  end
end
