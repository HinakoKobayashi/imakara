class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id
      t.string :action
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end
