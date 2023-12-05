class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :body
      t.integer :checked

      t.timestamps
    end
  end
end
