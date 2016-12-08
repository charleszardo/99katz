class AddRequesterIdToCatRentalRequests < ActiveRecord::Migration
  def change
    add_column :cat_rental_requests, :requester_id, :integer, null: false, default: 100000000
    add_index :cat_rental_requests, :requester_id
  end
end
