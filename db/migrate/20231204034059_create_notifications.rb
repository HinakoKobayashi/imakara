class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.string :notifiable_type, null: false
      t.integer :notifiable_id, null: false
      t.boolean :status, null: false, default: false

      t.timestamps
    end
  end
end
