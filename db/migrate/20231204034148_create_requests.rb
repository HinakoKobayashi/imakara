class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :confirmed
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
