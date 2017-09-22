class AddBannedToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :banned, :boolean
  end
end
