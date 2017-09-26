class AddDurationToVideos < ActiveRecord::Migration[5.1]
  def change
    add_column :videos, :duration, :integer
  end
end
