class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.text :post
      t.integer :post_status, null: false, default: 0
      t.text :address
      # MySQLに切り替えるタイミングでデータ型をdoubleに変更
      t.float :latitude
      t.float:longitude

      t.timestamps
    end
  end
end
