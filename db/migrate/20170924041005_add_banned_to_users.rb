class AddBannedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :banned, :timestamp, dedault: '1970-01-01 00:00:01'
  end
end
