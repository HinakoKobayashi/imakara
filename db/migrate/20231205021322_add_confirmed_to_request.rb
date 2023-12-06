class AddConfirmedToRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :confirmed, :integer
  end
end
