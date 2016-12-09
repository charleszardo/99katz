class AddDeviceTypeToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :device_type, :string, null: false, default: "unknown"
  end
end
