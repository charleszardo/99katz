class AddLocationToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :location, :string
  end
end
